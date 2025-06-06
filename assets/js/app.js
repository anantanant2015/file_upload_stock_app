// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "./topbar"
import * as chartHelper from "./chartHelper"
import { DragDropUpload } from "./hooks/dragDropUploadHook"
import { Chart } from "./hooks/chartHook"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    DragDropUpload,
    Chart
  }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

window.addEventListener("click1", e => {
  console.log("click event by user!", e.value)
});

window.addEventListener("submit", e => {

  console.log("click submit by user!", e.detail)
});

window.addEventListener("removedata", e => {
  chartHelper.clearChartCanvas('price-chart-canvas');
  console.log("remove data clicked!", e.chart_data)
});


window.addEventListener("adddata", e => {
  const chartConfig = JSON.parse(e.detail);

  chartHelper.renderChart('price-chart-canvas', chartConfig.type, chartConfig.chartData, chartConfig.chartOptions)
  console.log("add data clicked!", JSON.parse(e.detail));
});
// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
