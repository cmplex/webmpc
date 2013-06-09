// vim: tabstop=3 shiftwidth=3 noexpandtab
// @author Cedric Haase


var PERM_ENQUEUE_LTD = false;
var PERM_DEQUEUE_LTD = false;
var PERM_ENQUEUE		= false;
var PERM_DEQUEUE		= false;
var PERM_PAUSE			= false;
var PERM_SKIP			= false;
var PERM_VOLUME		= false;
var PERM_SKIPTO		= false;


$(document).ready(function(){
	
	/////////////////////////////////////////////////////////
	// C O O K I E  B A S E D  I M P L E M E N T A T I O N //
	/////////////////////////////////////////////////////////
	
	
	function setCookie(c_name, value, exdays) {
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);
		
		var c_value = escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
		
		document.cookie = c_name + "=" + c_value;
	}

	function getCookie(c_name) {
		var c_value = document.cookie;
		var c_start = c_value.indexOf(" " + c_name + "=");

		if(c_start == -1) {
			c_start = c_value.indexOf(c_name + "=");
		}

		if(c_start == -1) {
			c_value = null;
		}

		else {
			c_start = c_value.indexOf("=", c_start) + 1;
			var c_end = c_value.indexOf(";", c_start);
			if(c_end == -1) {
				c_end = c_value.length;
			}
			c_value = unescape(c_value.substring(c_start, c_end));
		}

		return c_value;
	}

	function checkCookie() {
		var userid = getCookie("userid");

		if (userid != null && userid != "") {
			alert("Welcome back! Your UserID is: "+userid);
		}
		else {
			// use number of milliseconds since 1970/01/01 as User ID
			var d_obj = new Date();
			var userid = d_obj.getTime();
			setCookie("userid", userid, 1);
		}
	}

	// checkCookie();

	//////////////////////////////////////////////////////////////////
	// H T M L 5  W E B  S T O R A G E  I M P L E M E N T A T I O N //
	//////////////////////////////////////////////////////////////////

	function checkSession () {
		if(localStorage.userid && localStorage.userstatus) {
			/*
			alert("Welcome back! Your UserID is: "+ localStorage.userid+"\n"+
			"Your status is: "+ localStorage.userstatus);
			*/
		}
		else {
			// Use number of milliseconds since 1970/01/01 as User ID
			var d_obj = new Date();
			localStorage.userid = d_obj.getTime();
			
			// Determine user status
			var userstatus = "guest";

			var statusid = 0;



			switch (userstatus) {
				case "admin":
					statusid = 3;

					window.PERM_ENQUEUE_LTD = true;
					PERM_DEQUEUE_LTD = true;
					PERM_ENQUEUE		= true;
					PERM_DEQUEUE		= true;
					PERM_PAUSE			= true;
					PERM_SKIP			= true;
					PERM_VOLUME		= true;
					PERM_SKIPTO		= true;

					break;


				case "privileged":
					statusid = 2;
				
					PERM_ENQUEUE_LTD = true;
					PERM_DEQUEUE_LTD = true;
					PERM_ENQUEUE		= false;
					PERM_DEQUEUE		= false;
					PERM_PAUSE			= true;
					PERM_SKIP			= false;
					PERM_VOLUME		= true;
					PERM_SKIPTO		= true;

					break;
				

				case "user":
					statusid = 1;

					PERM_ENQUEUE_LTD = true;
					PERM_DEQUEUE_LTD = true;
					PERM_ENQUEUE		= false;
					PERM_DEQUEUE		= false;
					PERM_PAUSE			= false;
					PERM_SKIP			= false;
					PERM_VOLUME		= false;
					PERM_SKIPTO		= false;

					break;


				case "guest":
					statusid = 0;

					PERM_ENQUEUE_LTD = true;
					PERM_DEQUEUE_LTD = true;
					PERM_ENQUEUE		= false;
					PERM_DEQUEUE		= false;
					PERM_PAUSE			= false;
					PERM_SKIP			= false;
					PERM_VOLUME		= false;
					PERM_SKIPTO		= false;

					break;

				default:
					statusid = 0;

					PERM_ENQUEUE_LTD = true;
					PERM_DEQUEUE_LTD = true;
					PERM_ENQUEUE		= false;
					PERM_DEQUEUE		= false;
					PERM_PAUSE			= false;
					PERM_SKIP			= false;
					PERM_VOLUME		= false;
					PERM_SKIPTO		= false;

					break;
			}

			localStorage.userstatus = statusid;

			// convert permission flags to binary permission map
			var permissions = 
			String(+PERM_ENQUEUE_LTD)+
			String(+PERM_DEQUEUE_LTD)+
			String(+PERM_ENQUEUE		)+
			String(+PERM_DEQUEUE		)+
			String(+PERM_PAUSE		)+
			String(+PERM_SKIP			)+
			String(+PERM_VOLUME		)+
			String(+PERM_SKIPTO		);

			// convert permission map to decimal integer
			permissions = parseInt(permissions, 2);

			localStorage.permissions = permissions;

		}
	}

	checkSession();

});
