import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HelloWorld extends HttpServlet {
  public void doGet(
    HttpServletRequest request,
    HttpServletResponse response
  )

  throws IOException, ServletException
  {

    /**
     *  Math.random関数で負荷をかける
     */
    int i = 0;
    double rand = 0;
    while (i < 10000) {
      rand += Math.random();
      i++;
    }

    /**
     * HelloWorldを返す
     */
    PrintWriter out = response.getWriter();
    out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">");
    out.println("<html>");
    out.println("<head>");
    out.println("<meta http-equiv=\"Pragma\" content=\"no-cache\"> <meta http-equiv=\"Cache-Control\" content=\"no-cache\"> <meta http-equiv=\"Expires\" content=\"0\">");
    out.println("<title>HelloWorld</title>");
    out.println("</head>");
    out.println("<body>");
    out.println("HelloWorld");
    out.println("</body>");
    out.println("</html>");
    out.close();
  }
}
