defmodule SwapChallengeGithubWeb.GithubSearchController do
  use SwapChallengeGithubWeb, :controller

  def create(conn, %{"user" => user, "repository" => repository}) do
    case fetch_github_data(user, repository) do
      {:ok, issues, contributors} ->
        spawn(fn ->
          payload = build_payload(user, repository, issues, contributors)
          send_webhook(payload)
        end)

        conn
        |> put_status(:ok)
        |> json(%{
          user: user,
          repository: repository,
          issues: issues,
          contributors: contributors
        })

      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: message})
    end
  end

  defp build_payload(user, repository, issues, contributors) do
    %{
      "user" => user,
      "repository" => repository,
      "issues" => issues,
      "contributors" => contributors
    }
  end

  defp fetch_github_data(user, repository) do
    case fetch_issues(user, repository) do
      {:ok, issues} ->
        case fetch_contributors(user, repository) do
          {:ok, contributors} ->
            {:ok, issues, contributors}

          {:error, message} ->
            {:error, message}
        end

      {:error, message} ->
        {:error, message}
    end
  end

  defp fetch_issues(user, repo) do
    url = "https://api.github.com/repos/#{user}/#{repo}/issues"
    headers = [{"User-Agent", "SwapChallengeGithub"}]

    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, parse_issues(body)}

      _ ->
        {:error, "An error occurred when trying to fetch repository issues from github"}
    end
  end

  defp parse_issues(body) do
    case Jason.decode(body) do
      {:ok, issues} when is_list(issues) ->
        issues |> Enum.map(&extract_issue_info/1)

      _ ->
        {:error, "An error occurred when trying to parse repository issues from github"}
    end
  end

  defp fetch_contributors(user, repo) do
    url = "https://api.github.com/repos/#{user}/#{repo}/contributors"
    headers = [{"User-Agent", "SwapChallengeGithub"}]

    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, parse_contributors(body)}

      _ ->
        {:error, "An error occurred when trying to fetch GitHub contributors"}
    end
  end

  defp parse_contributors(body) do
    case Jason.decode(body) do
      {:ok, contributors} when is_list(contributors) ->
        contributors |> Enum.map(&extract_contributor_info/1)

      _ ->
        {:error, "An error occurred when trying to parse repository contributors from github"}
    end
  end

  defp extract_issue_info(issue) do
    %{
      title: handle_empty_string(issue["title"]),
      author: handle_empty_string(issue["user"]["login"]),
      labels: handle_empty_list(issue["labels"])
    }
  end

  defp extract_contributor_info(contributor) do
    %{
      name: handle_empty_string(contributor["login"]),
      user: handle_empty_string(contributor["login"]),
      qtd_commits: handle_empty_int(contributor["contributions"])
    }
  end

  defp send_webhook(payload) do
    headers = [{"Content-Type", "application/json"}]
    body = Jason.encode!(payload)

    case HTTPoison.post(
           "https://webhook.site/226cd431-8308-4de6-a058-0135039a499a",
           body,
           headers
         ) do
      {:ok, _} -> {:ok}
      {:error, reason} -> {:error, reason}
    end
  end

  defp format_issues(issues) do
    issues |> Enum.map(&format_issue/1)
  end

  defp format_issue(issue) do
    %{title: issue.title, author: issue.author, labels: issue.labels}
  end

  defp format_contributors(contributors) do
    contributors |> Enum.map(&format_contributor/1)
  end

  defp format_contributor(contributor) do
    %{name: contributor.name, user: contributor.user, qtd_commits: contributor.qtd_commits}
  end

  defp handle_empty_value(nil, default) do
    default
  end

  defp handle_empty_value(value, _default) do
    value
  end

  defp handle_empty_string(value) do
    handle_empty_value(value, "")
  end

  defp handle_empty_list(value) do
    handle_empty_value(value, [])
  end

  defp handle_empty_int(value) do
    handle_empty_value(value, 0)
  end
end
