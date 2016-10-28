<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.ArrayList"%>
<html class=""><head>
<style class="cp-pen-styles">
    body {
  /*background: #161616;*/
  background: white;
  font-family: 'Source Sans Pro', sans-serif;
  font-size: 16px;
  font-weight: 400;
  color: black;
}

.content {
  width: 920px;
  margin: 20px auto;
  padding: 20px;
  box-sizing: border-box;
}

h1 {
  font-family: 'Titillium Web', sans-serif;
  font-weight: 600;
  font-size: 3em;
  text-transform: uppercase;
  margin-bottom: 0.2em;
}

.subtitle {
  font-weight: 300;
  font-size: 1.5em;
}

.graph {
  display: block;
  margin-top: 20px;
}
.graph__bar {
  fill: #bc3636;
}
.graph__axis text {
  fill: black;
}
.graph__axis--x {
  opacity: 0.5;
}
.graph__axis--x line {
  stroke: #fff;
  stroke-opacity: 0.2;
}
.graph__axis--x .domain {
  fill: none;
  stroke: none;
  shape-rendering: crispEdges;
}
.graph__axis--y text {
  font-family: 'Titillium Web', sans-serif;
  font-weight: 600;
  text-transform: uppercase;
}
.graph__axis--y path, .graph__axis--y line {
  fill: none;
  stroke: none;
}
.graph__tooltip {
  padding: 0.5em;
  background: #444;
}
.graph__tooltip:before {
  content: '';
  display: block;
  width: 0;
  height: 0;
  position: absolute;
  right: 100%;
  top: 50%;
  margin-top: -6px;
  border: 6px solid transparent;
  border-right-color: #444;
}
.graph__units-select {
  padding: 0  0.8em 0 0.5em;
  margin-top: 1em;
  font-size: inherit;
  font-family: inherit;
  color: inherit;
  background: none;
  /*border: none;*/
  -webkit-appearance: none;
     -moz-appearance: none;
          appearance: none;
  background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="6" viewBox="0 0 10 5.9999998"><path d="M10 0H0l5 6z" fill="white"/></svg>');
  background-repeat: no-repeat;
  background-position: right center;
}
.graph__units-select option {
  background: white;
}
</style></head><body>

<div class="content">
  <h1>Most Sales</h1>
  <!--<p class="subtitle">Most  (since the beginning of time)</p>-->
  <div id="show-graph"></div>
    
  <script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js"></script><script src="https://cdn.rawgit.com/Caged/d3-tip/07cf158c54cf1686b3000d784ef55d27b095cc0e/index.js"></script>
 <%
                String date = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                String month = new SimpleDateFormat("MM").format(new java.util.Date());
                String monthname = new SimpleDateFormat("MMMM").format(new java.util.Date());
                String year = new SimpleDateFormat("YYYY").format(new java.util.Date());
                String[] mths = {"January",
                    "February",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August",
                    "September",
                    "October",
                    "November",
                    "December"};
                ArrayList<String[]> weekLeadConfirmation = LeadDAO.getWeekLeadConfirmation(date);
                int mon = 0;
                int tues = 0;
                int weds = 0;
                int thurs = 0;
                int fri = 0;
                int sat = 0;
                int sun = 0;
                double total = 0;
                DecimalFormat df = new DecimalFormat("##.00");
                for (String[] rec : weekLeadConfirmation) {
                    String leadId = rec[0];
                    double totalAmt = Double.parseDouble(rec[1]);
                    total += totalAmt;
                    String nameOfDay = rec[2];
                    switch (nameOfDay) {
                        case "Monday":
                            mon++;
                            break;
                        case "Tuesday":
                            tues++;
                            break;
                        case "Wednesday":
                            weds++;
                            break;
                        case "Thursday":
                            thurs++;
                            break;
                        case "Friday":
                            fri++;
                            break;
                        case "Saturday":
                            sat++;
                            break;
                        case "Sunday":
                            sun++;
                            break;
                    }

                }
                int[] data = new int[7];
                data[0] = mon;
                data[1] = tues;
                data[2] = weds;
                data[3] = thurs;
                data[4] = fri;
                data[5] = sat;
                data[6] = sun;
            %>
  <script>
    function Show(title, watchedEpisodes, episodeLength) {
    this.title = title;
    this.watchedEpisodes = watchedEpisodes;
    this.episodeLength = episodeLength;
}
  function Sales(days, weeklySales) {
    this.days = days;
    this.weeklySales = weeklySales;
}
  function yearSales(mths, yearSales) {
    this.mths = mths;
    this.yearSales = yearSales;
}
Show.prototype.getWatchedHours = function () {
    return this.watchedEpisodes * this.episodeLength / 60;
};
Sales.prototype.getWeeklySales = function () {
    return this.weeklySales;
};
     var data = [];
     var yearSalesData = [];
                <%
                    for (int i = 0; i < data.length; i++) {
                       String  day = "";
            switch (i) {
                        case 0:
                            day = "Monday";
                            break;
                        case 1:
                            day =  "Tuesday";
                            break;
                        case 2:
                            day = "Wednesday";
                            break;
                        case 3:
                            day = "Thursday";
                            break;
                        case 4:
                            day = "Friday";
                            break;
                        case 5:
                            day = "Saturday";
                            break;
                        case 6:
                           day = "Sunday";
                            break;
                    }

                %>
               
                            
//            data[<%= i%>] = new Show("<%=day%>", <%=data[i]%>, 0);   //Here is the latest update check it sravan .Put single quotes.
            data[<%= i%>] = new Sales("<%=day%>", <%=data[i]%>);     
            <%}
                   
       
                %>
//var data = [
//   new Show('Monday', 3000, 25),
//    new Show('Tuesday', 62, 45),
//    new Show('Wednesday', 59, 45),
//    new Show('Thursday', 50, 60),
//    new Show('Friday', 39, 60),
//    new Show('Saturday', 30, 45),
//    new Show('Sunday', 29, 45)
//];
function createGraph() {
    var margin = {
            top: 20,
            right: 20,
            bottom: 20,
            left: 160
        }, w = 800 - margin.left - margin.right, h = 300 - margin.top - margin.bottom;
    var svg = d3.select('#show-graph').append('svg').attr('class', 'graph').attr('width', w + margin.left + margin.right).attr('height', h + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');
    var dropdownContainer = d3.select('#show-graph').append('div').style('margin-left', margin.left + 'px').style('width', w + 'px').style('text-align', 'center');
    var tip = d3.tip().attr('class', 'graph__tooltip').direction('e').offset([
        0,
        10
    ]);
    var xScale = d3.scale.linear().domain([0]).range([
        0,
        w
    ]);
//    var yScale = d3.scale.ordinal().domain([0, d3.max(data.length)]).rangeRoundBands([
//        0,
//        h
//    ], 0.6);
    var yScale = d3.scale.ordinal().domain(data.sort(function (a, b) {
        return d3.descending(a.getWeeklySales(), b.getWeeklySales());
    }).map(function (d) {
        return d.days;
    })).rangeRoundBands([
        0,
        h
    ], 0.6);
    var yAxis = d3.svg.axis().scale(yScale).orient('left');
    var xAxis = d3.svg.axis().scale(xScale).orient('bottom').tickSize(h).tickPadding(8);
    var dropdown = dropdownContainer.append('select').attr('class', 'graph__units-select');
    dropdown.append('option').attr('value', 'Yearly').text('Yearly');
    dropdown.append('option').attr('value', 'Weekly').text('Weekly');
    dropdown.on('change', function () {
        updateGraph(this.value);
    });
    svg.call(tip);
    svg.append('g').attr('class', 'graph__axis graph__axis--y').call(yAxis);
    svg.append('g').attr('class', 'graph__axis graph__axis--x').call(xAxis);
    var bar = svg.selectAll('g.bar').data(data).enter().append('g').attr('class', 'bar');
    bar.append('rect').attr('x', 0).attr('y', function (d) {
        //return yScale(d.title);
        return yScale(d.days);
    }).attr('height', yScale.rangeBand()).attr('width', 0).attr('class', 'graph__bar').on('mouseover', tip.show).on('mouseout', tip.hide);
    updateGraph(dropdown.value);
    
    function updateGraph(units) {
        var barSize;
        if (units == 'Yearly') {
            xScale.domain([
                0,
                d3.max(data, function (d) {
                    return d.weeklySales;
                })
            ]);
            tip.html(function (d) {
               // return d.watchedEpisodes;
                 return d.weeklySales;
            });
            barSize = function (d) {
//                return xScale(d.watchedEpisodes);
                 return xScale(d.weeklySales);
            };
        } else if(units == 'Weekly') {
            xScale.domain([
                0,
                d3.max(data, function (d) {
                    //return d.getWatchedHours();
                    return d.getWeeklySales();
                })
            ]);
            tip.html(function (d) {
//                return d3.round(d.getWatchedHours(), 2) + ' hrs';
                return d.getWeeklySales() + ' sales';
            });
            barSize = function (d) {
                return xScale(d.getWeeklySales());
            };
        }
        var svgTransitioning = svg.transition();
        svgTransitioning.select('.graph__axis--x').duration(1000).call(xAxis);
        svgTransitioning.selectAll('.graph__bar').duration(1000).attr('width', barSize);
    }
}
createGraph();
//# sourceURL=pen.js
</script>
<div class="graph__tooltip" style="position: absolute; top: 0px; opacity: 0; pointer-events: none; box-sizing: border-box;"></div>
</div>
</body></html>