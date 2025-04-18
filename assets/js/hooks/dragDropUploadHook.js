export const DragDropUpload = {
  mounted() {
    const dropArea = this.el;
    const fileInput = dropArea.querySelector("input[type='file']");

    dropArea.addEventListener("dragover", (e) => {
      e.preventDefault();
      dropArea.style.background = "#eef";
    });

    dropArea.addEventListener("dragleave", () => {
      dropArea.style.background = "";
    });

    dropArea.addEventListener("drop", (e) => {
      e.preventDefault();
      dropArea.style.background = "";

      const files = e.dataTransfer.files;
      fileInput.files = files;

      fileInput.dispatchEvent(new Event("change", { bubbles: true }));
    });
  }
}
