using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace TelerikWebAppInlineGrid
{
    public class Employee
    {
        #region Private fields

        private int _EmployeeID;

        private string _LastName;

        private string _FirstName;

        private string _Title;

        private string _TitleOfCourtesy;

        private System.Nullable<System.DateTime> _BirthDate;

        private string _Notes;

        #endregion

        #region Constructors

        public Employee()
        {
        }

        public Employee(SqlDataReader reader)
        {
            _EmployeeID = Convert.ToInt32(reader["EmployeeID"]);
            _LastName = reader["LastName"].ToString();
            _FirstName = reader["FirstName"].ToString();
            _Title = reader["Title"].ToString();
            _TitleOfCourtesy = reader["TitleOfCourtesy"].ToString();
            _BirthDate = Convert.ToDateTime(reader["BirthDate"]);
            _Notes = reader["Notes"].ToString();
        }

        #endregion

        #region Public properties

        public int EmployeeID
        {
            get
            {
                return this._EmployeeID;
            }
            set
            {
                if ((this._EmployeeID != value))
                {
                    this._EmployeeID = value;
                }
            }
        }

        public string LastName
        {
            get
            {
                return this._LastName;
            }
            set
            {
                if ((this._LastName != value))
                {
                    this._LastName = value;
                }
            }
        }

        public string FirstName
        {
            get
            {
                return this._FirstName;
            }
            set
            {
                if ((this._FirstName != value))
                {
                    this._FirstName = value;
                }
            }
        }

        public string Title
        {
            get
            {
                return this._Title;
            }
            set
            {
                if ((this._Title != value))
                {
                    this._Title = value;
                }
            }
        }

        public string TitleOfCourtesy
        {
            get
            {
                return this._TitleOfCourtesy;
            }
            set
            {
                if ((this._TitleOfCourtesy != value))
                {
                    this._TitleOfCourtesy = value;
                }
            }
        }

        public System.Nullable<System.DateTime> BirthDate
        {
            get
            {
                return this._BirthDate;
            }
            set
            {
                if ((this._BirthDate != value))
                {
                    this._BirthDate = value;
                }
            }
        }

        public string Notes
        {
            get
            {
                return this._Notes;
            }
            set
            {
                if ((this._Notes != value))
                {

                    this._Notes = value;
                }
            }
        }

        #endregion
     
    }
}