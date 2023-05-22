# Swap Challenge Github

This is a simple Elixir application that fetches and processes data from the Github API for a given user and repository. It retrieves information about the repository's issues and contributors, and sends the processed data as a payload to a webhook.

## Author
Elaine Gomes. I am a software engineer with over 10 years of experience in various technologies. I am currently a technical manager at another company, I am looking forward to joining Swap and I am loving learning Elixir and functional programming.

## Getting Started

These instructions will guide you on how to run the application locally and make use of its functionalities.

### Prerequisites

To run this application, you need to have Elixir installed on your machine. You can find the installation instructions at the [official Elixir website](https://elixir-lang.org/install.html).

### Installation

1. Clone the repository:

   ```shell
   git clone https://github.com/your-username/swap-challenge-github.git
   ```

2. Navigate to the project's directory:

   ```shell
   cd swap-challenge-github
   ```

3. Install dependencies:

   ```shell
   mix deps.get
   ```

4. Run application:

   ```shell
   mix phx.server
   ```

5. Test request
   ```shell
   curl --location 'http://localhost:4000/api/github/search' \
    --header 'Content-Type: application/json' \
    --data '{
        "user": "owner-repository-name",
        "repository": "repository-name"
    }'
   ```

   
