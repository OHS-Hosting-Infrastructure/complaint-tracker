const openForm = function () {
  const form = document.querySelector("#tta-activity-form")
  form.classList.remove("display-none") 
}

const closeForm = function () {
  const input = document.querySelector("#tta-report-id")
  input.value = ""
  const form = document.querySelector("#tta-activity-form")
  form.classList.add("display-none")
}

document.querySelector("#js-add-tta-report").addEventListener("keydown", event => {
  if (event.keyCode == 32) {
    event.preventDefault()
    openForm()
  }
})

document.querySelector("#js-close-tta-form").addEventListener("keydown", event => {
  if (event.keyCode == 32) {
    event.preventDefault()
    closeForm()
  }
})


document.querySelector("#js-add-tta-report").addEventListener('click', event => {
  openForm()
})


document.querySelector("#js-close-tta-form").addEventListener('click', event => {
  closeForm()
})
