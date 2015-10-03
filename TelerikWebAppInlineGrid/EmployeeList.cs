using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;
using TelerikWebAppInlineGrid;

/// <summary>
/// Summary description for EmployeesList
/// </summary>
public class EmployeesList : List<Employee>
{
    #region Constuctors

    public EmployeesList()
    {
        LoadAllEmployees();
    }

    #endregion

    #region Helper methods

    private void LoadAllEmployees()
    {
        if (this.Count > 0)
            this.Clear();

        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NorthwindConnectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand("SELECT [EmployeeID], [LastName], [FirstName], [Title], [TitleOfCourtesy], [BirthDate], [Notes] FROM [Employees]", conn);
        cmd.CommandType = CommandType.Text;

        try
        {

            conn.Open();

            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                this.Add(new Employee(dr));
            }

        }
        finally
        {
            conn.Close();
        }
    }

    public Employee GetEmployeeByEmployeeID(int id)
    {
        foreach (Employee employee in this)
        {
            if (employee.EmployeeID == id)
            {
                return employee;
            }
        }
        return null;
    }

    #endregion
}