window.addEventListener("turbolinks:load", calendar);

function calendar () {
  const displayYear = document.getElementById("display-year").innerHTML;
  const displayMonth = document.getElementById("display-month").innerHTML;
  const dates = document.querySelectorAll(".date");
  const wDayNum = document.getElementById("wday_num").innerHTML;
  const eachSums = document.querySelectorAll(".each-sum");
  

  setDateNumber(displayYear, displayMonth, dates, wDayNum);

  const daySums = document.querySelectorAll(".day-sum");
  for (let i=0; i < eachSums.length; i++) {
    if (eachSums[i].innerHTML != 0) {
      daySums[i].insertAdjacentHTML('afterbegin', `${eachSums[i].innerHTML}円`);
    };
  };

  const bottom = document.getElementById("bottom");
  const bottomLeft = document.getElementById("bottom-left");

  if (bottomLeft.getAttribute("style") == "background-color: lightgrey;") {
    const rows = document.querySelectorAll(".row");
    for (let i=0; i < rows.length; i++) {
      rows[i].setAttribute("style", "height: calc(100% / 5);")
    };
    bottom.setAttribute("style", "display: none;");
  };
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

function setDateNumber (year, month, dates, wDayNum) {
  let k = getLastDayNum(year, month) - Number(wDayNum) + 1;
  let flag = 1
  for(let i=0; i < dates.length; i++) {
    if (flag == 1) {
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num'>${k}</div>`);
      k += 1;
      dates[i].setAttribute("style", "background-color: lightgrey;");
      if (k > getLastDayNum(year, month)) {
        k = 1;
        flag = 0;
      };
    } else {
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num'>${k}</div><div class='day-sum'></div>`);
      k += 1;
      if (k > getDayNum(year, month)) {
        k = 1;
        flag = 1;
      };
    };
  };
};