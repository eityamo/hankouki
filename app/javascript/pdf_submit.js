document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector("form[data-pdf-form]");
  if (!form) return;

  form.addEventListener("submit", () => {
    const button = form.querySelector("input[type=submit]");
    if (!button) return;

    const timeout = parseInt(form.dataset.pdfTimeout, 10) || 10000;

    button.disabled = true;
    button.value = button.dataset.submitting || "...";
    button.classList.add("opacity-50", "cursor-not-allowed");

    // ブラウザが PDF を受信したらボタンを復元
    setTimeout(() => {
      button.disabled = false;
      button.value = button.dataset.original;
      button.classList.remove("opacity-50", "cursor-not-allowed");
    }, timeout);
  });
});
