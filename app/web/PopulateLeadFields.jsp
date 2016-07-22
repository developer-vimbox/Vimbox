<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<String> sources = LeadPopulationDAO.getSources();
    ArrayList<String> referrals = LeadPopulationDAO.getReferrals();
    ArrayList<String> types = LeadPopulationDAO.getLeadTypes();
    ArrayList<String> moveTypes = LeadPopulationDAO.getMoveTypes();
%>
