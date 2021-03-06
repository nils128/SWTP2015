package action;

import issuetracking.DBManager;
import issuetracking.User;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterAction implements Action {

	private static final DBManager DBManager1 = DBManager.getInstance();

	@Override
	public String execute(HttpServletRequest request,HttpServletResponse response) {

		Map<String, String> errorMsgs = new HashMap<String, String>();
		String regSuccess = null;
		String useridinput = request.getParameter("useridinput");
		String passwordinput = request.getParameter("passwordinput");

		errorMsgs = User.validateUserRegistration(useridinput, passwordinput);
		if (errorMsgs.isEmpty()) {
			DBManager1.registerUser(useridinput, passwordinput);
			regSuccess = "Du wurdest registriert";
		}
		request.setAttribute("errorMsgsReg", errorMsgs);
		request.setAttribute("regSuccess", regSuccess);
		if ("register".equals(request.getParameter("action")))
			return "login.jsp";
		else
			return "users.jsp";
	}
}