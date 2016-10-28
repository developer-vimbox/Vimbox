<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<html class=""><head>

        <style class="cp-pen-styles">
            rect:hover {
                fill: orange;
            }

            body {
                margin: 1em;
            }
            
            #chartArea {
                background: #e9e9e9;
                height: 250px;
                width: 400px;
                margin: 0 auto 1rem;
                padding: 0;
            }

            .bar {
                display: inline-block;
                cursor: pointer;  
            }

            a.button {
                background: #0099aa;
                padding: 1rem 1.5rem;
                margin: .5rem;
                display: inline-block;
                color: white;
                text-decoration: none;

                &:hover {
                    background: darken(#0099aa, 5);
                }
            </style></head><body>
            <%!
    //            public static String toJavascriptArray(String[] arr) {
    //                StringBuffer sb = new StringBuffer();
    //                sb.append("[");
    //                for (int i = 0; i < arr.length; i++) {
    //                    sb.append("\"").append(arr[i]).append("\"");
    //                    if (i + 1 < arr.length) {
    //                        sb.append(",");
    //                    }
    //                }
    //                sb.append("]");
    //                return sb.toString();
    //            }
%>
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
            <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/4.2.2/d3.min.js"></script>
            <script>
                var tempset = new Array();
                 var dataset = []
                tempset<%
                    for (int i = 0; i < data.length; i++) {
                %>
                dataset[<%= i%>] = <%=data[i]%>;   //Here is the latest update check it sravan .Put single quotes.
                <%}
                   
       
                %>
                    
//      var w = 600, h = 300, padding = 25, barPadding = 1, maxValue = 25, sortOrder = false;           
//    var xScale = d3.scaleBand().domain(d3.range(dataset.length)).rangeRound([ 0,w
//                ], 0.1).paddingInner(0.3);
//
//                var yScale = d3.scaleLinear()
//                        .domain([0, d3.max(dataset) * 1.1])
//                        .range([0, h]);
//
//                var colorScale = d3.scaleLinear()
//                        .domain([0, d3.max(dataset)])
//                        .range(['#0066aa', '#0099aa']);
//
//                console.log(dataset);
//                var svg = d3.select('body').append('svg').attr('width', w).attr('height', h);
//                svg.selectAll('rect')
//                        .transition()
//                        .duration(300)
//                        .delay(function (d, i) {
//                            return i * 10;
//                        })
//                        .attr('x', function (d) {
//                            return xScale(d);
//                        })
//                        .attr('y', function (d) {
//                            return h - yScale(d);
//                        });

                var w = 600, h = 300, padding = 25, barPadding = 1, maxValue = 25, sortOrder = false;
                var xScale = d3.scaleBand().domain(d3.range(dataset.length)).rangeRound([
                    0,
                    w
                ], 0.05).paddingInner(0.05);
                var yScale = d3.scaleLinear().domain([
                    0,
                    d3.max(dataset)
                ]).range([
                    0,
                    h
                ]);
                var svg = d3.select('body').append('svg').attr('width', w).attr('height', h);
                svg.selectAll('rect').data(dataset).enter().append('rect').attr('x', function (d, i) {
                    return xScale(i);
                }).attr('y', function (d) {
                    return h - yScale(d);
                }).attr('width', xScale.bandwidth()).attr('height', function (d) {
                    return yScale(d);
                }).attr('fill', function (d) {
                    return 'rgb(0, 0, ' + d * 10 + ')';
                }).on('click', function () {
                    sortBars();
                }).on('mouseover', function (d) {
                    var xPosition = parseFloat(d3.select(this).attr('x')) + xScale.bandwidth() / 2;
                    var yPosition = parseFloat(d3.select(this).attr('y')) + 14;
                    svg.append('text').attr('id', 'tooltip').attr('x', xPosition).attr('y', yPosition).attr('text-anchor', 'middle').attr('font-family', 'sans-serif').attr('font-size', '11px').attr('font-weight', 'bold').attr('fill', 'black').text(d);
                }).on('mouseout', function () {
                    d3.select('#tooltip').remove();
                });
                var sortBars = function () {
                    sortOrder = !sortOrder;
                    svg.selectAll('rect').sort(function (a, b) {
                        if (sortOrder) {
                            return d3.ascending(a, b);
                        } else {
                            return d3.descending(a, b);
                        }
                    }).transition().delay(function (d, i) {
                        return i * 50;
                    }).duration(1000).attr('x', function (d, i) {
                        return xScale(i);
                    });
                };
            </script>
        </body></html>