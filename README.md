
# FileUploadStockApp

This is a Phoenix-based web application for uploading TSV (Tab-Separated Values) files containing stock data, rendering charts, and providing features like data aggregation, sorting, and symbol management.

### Features:
- **File Upload**: Allows users to upload TSV files for stock data processing.
- **Chart Rendering**: Provides chart visualization options, including scatter and line charts.
- **Data Aggregation**: Aggregates data hourly or daily for stock symbols.
- **Demo Mode**: Automatically generates demo data for visualization.
- **Data Management**: Allows users to delete all stored data from the database.

---

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Deployment](#deployment)
- [Configuration](#configuration)
- [Tests](#tests)
- [License](#license)

---

## Installation

### Prerequisites

- **Elixir** (version 1.14 or higher)
- **Erlang** (version 24 or higher)
- **PostgreSQL** (for local development, if not using Heroku/PostgreSQL)
- **Node.js** (version 16 or higher, for compiling assets)
- **Phoenix** (version 1.6 or higher)

### Steps to Install

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/file_upload_stock_app.git
   cd file_upload_stock_app
   ```

2. Install Elixir dependencies:
   ```bash
   mix deps.get
   ```

3. Install JavaScript dependencies:
   ```bash
   cd assets
   npm install
   cd ..
   ```

4. Create and migrate the database:
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

---

## Usage

1. **Start the Phoenix server**:
   ```bash
   mix phx.server
   ```
   The application will be available at `http://localhost:4000`.

2. **Features**:
   - **File Upload**: Upload your TSV file using the file upload form.
   - **Chart Rendering**: After uploading the file, select a symbol and aggregation type (hourly/daily) to display a chart.
   - **Demo Mode**: If no data exists in the system, a button to generate demo data will be available.
   - **Delete All Data**: Option to clear all data stored in the database.

---

## Deployment

### Deploy to Heroku

1. **Login to Heroku**:
   ```bash
   heroku login
   ```

2. **Create a Heroku app**:
   ```bash
   heroku create file-upload-stock-app
   ```

3. **Add PostgreSQL Add-on**:
   ```bash
   heroku addons:create heroku-postgresql:hobby-dev
   ```

4. **Set up environment variables**:
   Set `SECRET_KEY_BASE`:
   ```bash
   heroku config:set SECRET_KEY_BASE=$(mix phx.gen.secret)
   ```

5. **Deploy the app**:
   ```bash
   git push heroku master
   ```

6. **Run migrations**:
   ```bash
   heroku run mix ecto.create
   heroku run mix ecto.migrate
   ```

7. **Access the app**:
   Visit your app on Heroku using:
   ```bash
   heroku open
   ```

---

## Configuration

### Database Configuration

The app uses PostgreSQL. Make sure that your `config/prod.exs` is configured to use the Heroku database URL:

```elixir
config :file_upload_stock_app, FileUploadStockApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 15
```

### Secret Key Base

Make sure to set the `SECRET_KEY_BASE` environment variable on Heroku or in your local environment. You can generate a new one using:

```bash
mix phx.gen.secret
```

---

## Tests

1. **Run tests**:
   ```bash
   mix test
   ```

2. **Test coverage**: Ensure full coverage for modules like `FileUploadStockAppWeb.PageLive`, `FileUploadStockApp.DataQuery`, and `FileUploadStockApp.FileUtils`.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### Notes

Feel free to modify and enhance the `README.md` as per any additional features or changes that you may have in the project. This template covers the core setup and deployment information for Heroku, and you can extend it with any other custom deployment options or settings.
