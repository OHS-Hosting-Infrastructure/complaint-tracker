document.querySelector("#js-add-tta-report").addEventListener('click', event => {
  const form = document.querySelector("#tta-activity-form")
  form.classList.remove("display-none")
});

document.querySelector("#js-close-tta-form").addEventListener('click', event => {
  const input = document.querySelector("#tta_report_id")
  input.value = ""
  const form = document.querySelector("#tta-activity-form")
  form.classList.add("display-none")
});
