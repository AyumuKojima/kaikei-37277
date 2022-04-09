window.addEventListener("turbolinks:load", calendar);

function calendar () {
  const displayYear = document.getElementById("display-year").innerHTML;
  const displayMonth = document.getElementById("display-month").innerHTML;
  const firstRows = document.querySelectorAll(".row_1");
  const dates = document.querySelectorAll(".date");
  const wdayNum = document.getElementById("wday_num").innerHTML;
  
  setDateNumber(displayYear, displayMonth, dates, wdayNum);
};


function getDayNum (year, month) {
  return new Date(year, month, 0).getDate();
};

function getLastDayNum (year, month) {
  if (month == 1) {
    return getDayNum(Number(year)-1, 12);
  } else {
    return getDayNum(year, Number(month)-1);
  };
};

function setDateNumber (year, month, dates, wdayNum) {
  let k = getLastDayNum(year, month) - Number(wdayNum) + 1;
  let flag = 1
  for(let i=0; i < dates.length; i++) {
    dates[i].insertAdjacentHTML('afterbegin', k);
    k += 1;
    if (flag == 1) {
      dates[i].setAttribute("style", "background-color: lightgrey;");
      if (k > getLastDayNum(year, month)) {
        k = 1;
        flag = 0;
      };
    };
    if (flag == 0 && k > getDayNum(year, month)) {
      k = 1;
      flag = 1;
    };
  };
};