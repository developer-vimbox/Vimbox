<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%
    ArrayList<String> primaryServices = LeadPopulationDAO.getPrimaryServices();

    ArrayList<ArrayList<String>> secondaryServices = new ArrayList<ArrayList<String>>();
    int max = 0;
    for (String primaryService : primaryServices) {
        ArrayList<String> secondaryService = LeadPopulationDAO.getSecondaryServices(primaryService);
        for (int i = 0; i < secondaryService.size(); i++) {
            String secSvc = secondaryService.get(i);
            String formula = LeadPopulationDAO.getServiceFormula(primaryService, secSvc);
            String str = secSvc + "," + formula;
            secondaryService.set(i, str);
        }
        secondaryServices.add(secondaryService);
        if (secondaryService.size() > max) {
            max = secondaryService.size();
        }
    }
    String[][] serviceTable = new String[max + 1][primaryServices.size()];
    for (int i = 0; i < serviceTable.length; i++) {
        for (int j = 0; j < serviceTable[i].length; j++) {
            if (i == 0) {
                // Table Header //
                serviceTable[i][j] = primaryServices.get(j);
            } else {
                // Table Data //
                ArrayList<String> secSvc = secondaryServices.get(j);
                try {
                    serviceTable[i][j] = secSvc.get(i - 1);
                } catch (Exception e) {
                    serviceTable[i][j] = "";
                    e.printStackTrace();
                }
            }
        }
    }
%>
