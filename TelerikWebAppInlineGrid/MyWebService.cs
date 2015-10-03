using System;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using TelerikWebAppInlineGrid;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class MyWebService : System.Web.Services.WebService
{
    EmployeesList employeesList = null;

    public MyWebService()
    {
        employeesList = new EmployeesList();

        if (HttpContext.Current.Session["MyData"] == null)
        {
            HttpContext.Current.Session["MyData"] = employeesList;
        }
    }

    [WebMethod(EnableSession = true)]
    public EmployeesList UpdateEmployeeByEmployee(Employee employee)
    {
        Employee employeeToUpdate = GetEmployeeByEmployeeID(employee.EmployeeID);

        EmployeesList list = (EmployeesList)HttpContext.Current.Session["MyData"];

        if (employeeToUpdate == null)
        {
            employeeToUpdate = new Employee();
            employeeToUpdate.EmployeeID = employee.EmployeeID;

            list.Add(employeeToUpdate);
        }

        employeeToUpdate.LastName = employee.LastName;
        employeeToUpdate.FirstName = employee.FirstName;
        employeeToUpdate.Title = employee.Title;
        employeeToUpdate.TitleOfCourtesy = employee.TitleOfCourtesy;
        employeeToUpdate.BirthDate = employee.BirthDate;
        employeeToUpdate.Notes = employee.Notes;

        HttpContext.Current.Session["MyData"] = list;

        return list;
    }

    [WebMethod(EnableSession = true)]
    public EmployeesList DeleteEmployeeByEmployeeID(int employeeID)
    {
        Employee employeeToDelete = GetEmployeeByEmployeeID(employeeID);

        EmployeesList list = (EmployeesList)HttpContext.Current.Session["MyData"];
        list.Remove(employeeToDelete);

        HttpContext.Current.Session["MyData"] = list;

        return list;
    }


    [WebMethod(EnableSession = true)]
    public Employee GetEmployeeByEmployeeID(int employeeID)
    {
        EmployeesList list = (EmployeesList)HttpContext.Current.Session["MyData"];

        return list.GetEmployeeByEmployeeID(employeeID);
    }
}