defmodule FileUploadStockAppWeb.PageLive.FileUploadComponent do
  use FileUploadStockAppWeb, :live_component

  def mount(socket) do
    {:ok,
     allow_upload(socket, :tsv_file,
       accept: ~w(.tsv),
       max_entries: 3,
       max_file_size: 5_000_000,
       auto_upload: false,
       progress: &handle_progress/3
     )}
  end

  def render(assigns) do
    ~H"""
    <div>
      <form phx-submit="save" phx-change="validate" phx-target={@myself}>
        <div
          id="upload-drop-area"
          phx-hook="DragDropUpload"
          class="dropzone"
          style="border: 2px dashed #999; padding: 20px; text-align: center;"
        >
          <p><strong>Drop files here</strong> or click to select</p>
          <.live_file_input upload={@uploads.tsv_file} class="hidden-input" />
          <button type="button" onclick="document.querySelector('.hidden-input').click()">Select File</button>
        </div>

        <div class="upload-list">
          <%= for entry <- @uploads.tsv_file.entries do %>
            <div style="margin-top: 10px;">
              <strong><%= entry.client_name %></strong>
              <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>
              <%= if entry.done? do %> ✅ <% end %>

              <%= for err <- upload_errors(@uploads.tsv_file, entry) do %>
                <p style="color: red;"><%= Phoenix.Naming.humanize(err) %></p>
              <% end %>
            </div>
            <button type="submit">Upload</button>
          <% end %>
        </div>


      </form>
    </div>
    """
  end

  def handle_event("validate", _params, socket), do: {:noreply, socket}

  # Save files on submit
  def handle_event("save", _params, socket) do
    paths =
      consume_uploaded_entries(socket, :tsv_file, fn %{path: path}, entry ->
        File.mkdir_p!("uploads") # ensure uploads/ exists
        dest = Path.join("uploads", entry.client_name)
        File.cp!(path, dest)
        {:ok, dest}
      end)

    send(self(), {:uploaded, paths})
    {:noreply, socket}
  end

  def handle_progress(:tsv_file, _entry, socket), do: {:noreply, socket}
end
