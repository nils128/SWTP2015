package action;

import java.util.LinkedList;

import issuetracking.DBManager;
import issuetracking.Sprint;
import issuetracking.Ticket;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class DeleteSprintAction implements Action{
	
	private static final DBManager DBManager1 = DBManager.getInstance();

	@Override
	public String execute(HttpServletRequest request,
			HttpServletResponse response) {
		Sprint sprint1 = DBManager1.getSprintById(Integer.parseInt(request.getParameter("sprintid")));
		
		//alle seine Tickets die entfernt werden sollen auf sprintid -1 setzen.
		LinkedList<Ticket> tList=(LinkedList<Ticket>) DBManager1.getTicketsByState("beliebig", sprint1.getSprintid());
		if( tList!=null&&!(tList.isEmpty())){
			for(Ticket ticket1: tList){
				Ticket temptick = ticket1;
				temptick.setSprintid(-1);
				DBManager1.updateTicket(temptick);
			}}
		
		DBManager1.deleteSprint(sprint1);
		return "sprints.jsp";}

}