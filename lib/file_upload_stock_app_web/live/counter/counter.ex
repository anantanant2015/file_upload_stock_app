defmodule FileUploadStockAppWeb.Counter do
  use FileUploadStockAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:counter_value, nil)
     |> assign(:reset, false)
     |> assign(:trigger_get_value, false)}
  end

  def render(assigns) do
    ~H"""
    <div class="center-align padding">

      <h2 class="title">Parent LiveView</h2>

      <p><strong>Value from Child:</strong> <%= @counter_value || "Not yet fetched" %></p>

      <div class="row gap">
        <button class="button primary" phx-click="get_value">Get Value from Child</button>
        <button class="button secondary" phx-click="reset_all">Reset Both</button>
      </div>

      <.live_component
        module={FileUploadStockAppWeb.CounterComponent}
        id="counter"
        reset={@reset}
        trigger_get_value={@trigger_get_value}
      />

      <section class="mt-10 p-4 rounded shadow bg-zinc-100 text-zinc-900 border border-zinc-300">

        <h3 class="text-lg font-bold mb-4">🔄 Event Flow: LiveView &amp; LiveComponent (Parent–Child)</h3>

        <table class="table-auto w-full text-left border-collapse text-sm bg-yellow-50 text-zinc-900">
          <thead>
            <tr class="bg-gray-100 border-b">
              <th class="px-4 py-2">Who</th>
              <th class="px-4 py-2">Action</th>
              <th class="px-4 py-2">Code Involved</th>
            </tr>
          </thead>
          <tbody class="text-zinc-800">
            <tr class="border-b">
              <td class="px-4 py-2">👨‍💻 Parent (LiveView)</td>
              <td class="px-4 py-2">User clicks &quot;Get Value from Child&quot;</td>
              <td class="px-4 py-2">
                <code class="bg-blue-50 text-zinc-900">handle_event(&quot;get_value&quot;)</code> → assigns <code class="bg-blue-50 text-zinc-900">trigger_get_value = true</code>
              </td>
            </tr>
            <tr class="border-b">
              <td class="px-4 py-2">👶 Child (LiveComponent)</td>
              <td class="px-4 py-2">Detects <code class="bg-blue-50 text-zinc-900">trigger_get_value</code> in <code class="bg-blue-50 text-zinc-900">update/2</code></td>
              <td class="px-4 py-2">
                Sends message: <code class="bg-blue-50 text-zinc-900">send(self(), &#123;:child_value, count&#125;)</code>
              </td>
            </tr>
            <tr class="border-b">
              <td class="px-4 py-2">👨‍💻 Parent (LiveView)</td>
              <td class="px-4 py-2">Handles message from child</td>
              <td class="px-4 py-2">
                <code class="bg-blue-50 text-zinc-900">handle_info(&#123;:child_value, count&#125;)</code> → assigns <code class="bg-blue-50 text-zinc-900">@counter_value</code>
              </td>
            </tr>
            <tr class="border-b">
              <td class="px-4 py-2">👨‍💻 Parent (LiveView)</td>
              <td class="px-4 py-2">User clicks &quot;Reset Both&quot;</td>
              <td class="px-4 py-2">
                <code class="bg-blue-50 text-zinc-900">handle_event(&quot;reset_all&quot;)</code> → assigns <code class="bg-blue-50 text-zinc-900">reset = true</code>
              </td>
            </tr>
            <tr class="border-b">
              <td class="px-4 py-2">👶 Child (LiveComponent)</td>
              <td class="px-4 py-2">Detects <code class="bg-blue-50 text-zinc-900">reset = true</code> in <code class="bg-blue-50 text-zinc-900">update/2</code></td>
              <td class="px-4 py-2">
                Resets internal <code class="bg-blue-50 text-zinc-900">@count = 0</code>
              </td>
            </tr>
          </tbody>
        </table>

        <p class="text-xs mt-4 text-zinc-600">
          🧠 = Parent LiveView &nbsp;&nbsp;&nbsp; 👶 = Child LiveComponent &nbsp;&nbsp;&nbsp; 🔁 = Data sent via assigns &amp; messages
        </p>
      </section>


    </div>
    """
  end

  def handle_info({:child_value, count}, socket) do
    {:noreply, assign(socket, :counter_value, count)}
  end

  def handle_event("get_value", _params, socket) do
    {:noreply,
     socket
     |> assign(:trigger_get_value, true)
     |> assign(:reset, false)}
  end

  def handle_event("reset_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:reset, true)
     |> assign(:trigger_get_value, false)
     |> assign(:counter_value, 0)}
  end
end
