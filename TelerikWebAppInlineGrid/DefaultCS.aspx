<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DefaultCS.aspx.cs" Inherits="TelerikWebAppInlineGrid.DefaultCS" %>
<%@ Register TagPrefix="sds" Namespace="Telerik.Web.SessionDS" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns='http://www.w3.org/1999/xhtml'>
<head runat="server">
    <title>Telerik ASP.NET Example</title>
    <link href="styles.css" rel="stylesheet" type="text/css" />
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    
        <script type="text/javascript">
            var employeeID, currentEmployee, currentRowIndex = null;

            var employee =
            {
                EmployeeID: null,
                FirstName: null,
                LastName: null,
                Title: null,
                TitleOfCourtesy: null,
                BirthDate: null,
                Notes: null,

                create: function () {
                    var obj = new Object();

                    obj.EmployeeID = "";
                    obj.FirstName = "";
                    obj.LastName = "";
                    obj.Title = "";
                    obj.TitleOfCourtesy = "";
                    obj.BirthDate = "";
                    obj.Notes = "";

                    return obj;
                }
            };

            function getDataItemKeyValue(radGrid, item) {
                return parseInt(radGrid.get_masterTableView().getCellByColumnUniqueName(item, "EmployeeID").innerHTML);
            }

            function pageLoad(sender, args) {
                //employeeID = $find("<%= RadGrid1.ClientID %>").get_masterTableView().get_dataItems()[0].getDataKeyValue("EmployeeID");
                employeeID = getDataItemKeyValue($find("<%= RadGrid1.ClientID %>"), $find("<%= RadGrid1.ClientID %>").get_masterTableView().get_dataItems()[0]);
                $find("<%= LastName.ClientID %>").focus();
                currentRowIndex = 0;
            }

            function rowSelected(sender, args) {
                employeeID = getDataItemKeyValue(sender, args.get_gridDataItem());

                currentRowIndex = args.get_gridDataItem().get_element().rowIndex;

                $find("<%= RadTabStrip1.ClientID %>").set_selectedIndex(0);

                MyWebService.GetEmployeeByEmployeeID(employeeID, setValues)
            }

            function setValues(employee) {
                $get("<%= EmployeeID.ClientID %>").innerHTML = employee.EmployeeID;

                $find("<%= LastName.ClientID %>").set_value(employee.LastName);
                $find("<%= FirstName.ClientID %>").set_value(employee.FirstName);
                $find("<%= Title.ClientID %>").set_value(employee.Title);
                $find("<%= TitleOfCourtesy.ClientID %>").findItemByText(employee.TitleOfCourtesy).select();
                $find("<%= BirthDate.ClientID %>").set_selectedDate(employee.BirthDate);
                $find("<%= Notes.ClientID %>").set_html(employee.Notes);

                $find("<%= LastName.ClientID %>").focus();
            }

            function getValues() {
                employee.EmployeeID = $get("<%= EmployeeID.ClientID %>").innerHTML;

                employee.LastName = $find("<%= LastName.ClientID %>").get_value();
                employee.FirstName = $find("<%= FirstName.ClientID %>").get_value();
                employee.Title = $find("<%= Title.ClientID %>").get_value();
                employee.TitleOfCourtesy = $find("<%= TitleOfCourtesy.ClientID %>").get_value();
                employee.BirthDate = $find("<%= BirthDate.ClientID %>").get_selectedDate();
                employee.Notes = $find("<%= Notes.ClientID %>").get_html();

                return employee;
            }

            function updateChanges() {
                MyWebService.UpdateEmployeeByEmployee(getValues(), updateGrid);
            }

            function updateGrid(result) {
                var tableView = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                tableView.set_dataSource(result);
                tableView.dataBind();

                var grid = $find("<%= RadGrid1.ClientID %>");
                grid.repaint();
            }

            function tabSelected(sender, args) {
                if (currentEmployee == null) {
                    currentEmployee = getValues();
                }

                switch (args.get_tab().get_index()) {
                    case 1:
                        {
                            var gridItems = $find("<%= RadGrid1.ClientID %>").get_masterTableView().get_dataItems();
                            var newID = getDataItemKeyValue($find("<%= RadGrid1.ClientID %>"), gridItems[gridItems.length - 1]) + 1;

                            var newEmployee = employee.create();
                            newEmployee.EmployeeID = newID;
                            setValues(newEmployee);

                            $get("<%= SaveChanges.ClientID %>").value = "Add";
                            $get("<%= Delete.ClientID %>").style.display = "none";

                            break;
                        }
                    default:
                        {
                            setValues(currentEmployee);
                            currentEmployee = null;

                            $get("<%= SaveChanges.ClientID %>").value = "Save";
                            $get("<%= Delete.ClientID %>").style.display = "";

                            break;
                        }
                }
            }

            function deleteCurrent() {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                var row = masterTable.get_element().rows[currentRowIndex];
                masterTable._deleteRow(row, currentRowIndex);

                var gridItems = masterTable.get_dataItems();

                MyWebService.DeleteEmployeeByEmployeeID(employeeID, updateGrid);

                gridItems[gridItems.length - 1].set_selected(true);
            }

        </script>
    </telerik:RadCodeBlock>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
    <telerik:RadSkinManager ID="RadSkinManager1" runat="server" ShowChooser="true" />
    <telerik:RadFormDecorator ID="RadFormDecorator1" runat="server" DecorationZoneID="demo" EnableRoundedCorners="false" DecoratedControls="All" />
    <div id="demo" class="demo-container no-bg">
        <telerik:RadGrid ID="RadGrid1" CssClass="grid" DataSourceID="SqlDataSource1" runat="server"
            GridLines="None" OnDataBound="RadGrid1_DataBound" OnColumnCreated="RadGrid1_ColumnCreated"
            Height="300px">
            <MasterTableView TableLayout="Fixed" ClientDataKeyNames="EmployeeID">
            </MasterTableView>
            <ClientSettings>
                <Selecting AllowRowSelect="true"></Selecting>
                <ClientEvents OnRowSelected="rowSelected"></ClientEvents>
                <Scrolling AllowScroll="true" UseStaticHeaders="true"></Scrolling>
            </ClientSettings>
        </telerik:RadGrid>
        <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConflictDetection="CompareAllValues"
            ConnectionString="<%$ ConnectionStrings:NorthwindConnectionString %>" SelectCommand="SELECT [EmployeeID], [LastName], [FirstName], [Title], [TitleOfCourtesy], [BirthDate], [Notes] FROM [Employees]">
        </asp:SqlDataSource>
        <telerik:RadTabStrip ID="RadTabStrip1" OnClientTabSelected="tabSelected" Style="margin-top: 10px;"
            SelectedIndex="0" runat="server">
            <Tabs>
                <telerik:RadTab Text="Edit employee">
                </telerik:RadTab>
                <telerik:RadTab Text="Add new employee">
                </telerik:RadTab>
            </Tabs>
        </telerik:RadTabStrip>
        <div style="border: 1px solid threedshadow;">
            <table border="0" style="margin-top: 20px; width: 100%;table-layout:fixed">
                <colgroup>
                    <col style="width:200px" />
                </colgroup>
                <tr>
                    <td>
                        Employee ID:
                    </td>
                    <td>
                        <asp:Label ID="EmployeeID" Style="float: left; font-weight: bold" runat="server"></asp:Label>
                        <telerik:RadButton ID="SaveChanges" OnClientClicked="updateChanges" Text="Save" AutoPostBack="false"
                             runat="server" Width="90px" CssClass="saveBtn"></telerik:RadButton>
                        <telerik:RadButton ID="Delete" Width="90px" OnClientClicked="deleteCurrent" AutoPostBack="false"
                            Text="Delete" runat="server" CssClass="deleteBtn"></telerik:RadButton>
                    </td>
                </tr>
                <tr>
                    <td>
                        Last name:
                    </td>
                    <td>
                        <telerik:RadTextBox ID="LastName" runat="server">
                        </telerik:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        First name:
                    </td>
                    <td>
                        <telerik:RadTextBox ID="FirstName" runat="server">
                        </telerik:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Title:
                    </td>
                    <td>
                        <telerik:RadTextBox ID="Title" runat="server">
                        </telerik:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Title of courtesy:
                    </td>
                    <td>
                        <telerik:RadComboBox ID="TitleOfCourtesy" runat="server">
                            <Items>
                                <telerik:RadComboBoxItem Text="" Value=""></telerik:RadComboBoxItem>
                                <telerik:RadComboBoxItem Text="Dr." Value="Dr."></telerik:RadComboBoxItem>
                                <telerik:RadComboBoxItem Text="Mr." Value="Mr."></telerik:RadComboBoxItem>
                                <telerik:RadComboBoxItem Text="Mrs." Value="Mrs."></telerik:RadComboBoxItem>
                                <telerik:RadComboBoxItem Text="Ms." Value="Ms."></telerik:RadComboBoxItem>
                            </Items>
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Birth date:
                    </td>
                    <td>
                        <telerik:RadDatePicker ID="BirthDate" MinDate="01/01/1900" runat="server">
                        </telerik:RadDatePicker>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top;">
                        Notes:
                    </td>
                    <td>
                        <telerik:RadEditor ID="Notes" SkinID="BasicSetOfTools" Width="100%" runat="server"
                            Height="400px">
                        </telerik:RadEditor>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>