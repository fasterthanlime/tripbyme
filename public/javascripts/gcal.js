// Converts the given time into UTC, returns this in a string
function getUTCDateString() {
    var timeObj = new Date();
    var dateStr = "" + timeObj.getUTCFullYear();
    dateStr += stringPad(timeObj.getUTCMonth()+1);
    dateStr += stringPad(timeObj.getUTCDate());
    dateStr += "T" + stringPad(timeObj.getUTCHours());
    dateStr += stringPad(timeObj.getUTCMinutes()) + "00Z";
    return dateStr;
} 

function generateCalendarURI(name, start_time, stop_time, lat, lng, description) {
    sname = encodeURI(name);
    sdates = encodeURI(start_time + "/" + stop_time);
    sdescription = encodeURI(description);
    slocation = encodeURI(lat + "," + lng);
    swebsite = encodeURI("planaday.ch");
    swebsitename = encodeURI("planaday");

    uri = "http://www.google.com/calendar/event?action=TEMPLATE";
    uri += "&text=" + sname;
    uri += "&dates=" + sdates;
    uri += "&location=" + slocation;
    uri += "&trp=fals&sprop=" + swebsite + "&sprop=name:" + swebsitename;

    return uri;
}

function generateCalendarButton(name, start_time, stop_time, lat, lng, description) {
    return '<a href="' + generateCalendarURI() + '" target="_blank"><img src="http://www.google.com/calendar/images/ext/gc_button6.gif" border=0></a>'

}
