function postSpend () {
  const submitBtn = document.getElementById("submit");
  submitBtn.addEventListener('click', (e) => {
    e.preventDefault();
    const form = document.getElementById("form");
    const formData = new FormData(form);
    XHR = setXHRandFormData();
    XHR.send(formData);
    XHR.onload = () => {
      if (XHR.status != 200) {
        alert(`Error ${XHR.status}: ${XHR.statusText}`);
        return null;
      };
      clearForm();
      rewriteCalendar(XHR);
    };
  });
};

function setXHRandFormData () {
  const year = document.getElementById("_day_1i");
  const month = document.getElementById("_day_2i");
  const XHR = new XMLHttpRequest();
  XHR.open("POST", `/years/${year.value}/months/${month.value}/spends`, true);
  XHR.responseType = "json";
  return XHR;
};

function clearForm () {
  const moneyForm = document.getElementById("money");
  const categoryForm = document.getElementById("category_id");
  const memoForm = document.getElementById("memo");
  moneyForm.value = "";
  categoryForm.value = 0;
  memoForm.value = "";
};

function rewriteCalendar (XHR) {
  const item = XHR.response.spend;
  const date = new Date(item.day);
  const currentYear = document.getElementById("display-year").innerHTML;
  const currentMonth = document.getElementById("display-month").innerHTML;
  if (date.getFullYear() == currentYear && date.getMonth()+1 == currentMonth) {
    const daySums = document.querySelectorAll(".day-sum");
    const monthSum = document.getElementById("month-sum");
    daySums[date.getDate()-1].innerHTML = `${XHR.response.day_sum}円`;
    monthSum.innerHTML = `合計出費額：${XHR.response.sum}円`;
  };
};

window.addEventListener('turbolinks:load', postSpend);