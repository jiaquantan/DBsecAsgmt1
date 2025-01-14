﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Employees.aspx.cs" Inherits="DBsecAsgmt1.Employees" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employees</title>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
    <style>
        .col-xs-12 h1 {
            font-weight: bold
        }
        body {
            /*background-color: whitesmoke;*/
        }
        .navbar {
            background-color: antiquewhite;
        }
        .navbar-nav > li {
            margin-right: 15px; /* Increase the gap between navbar buttons */
            margin-top: 20px;
        }
        .navbar-nav > li > a {
            color: black !important;
            transition: all 0.3s ease;
            font-size: 2rem;
        }
        .navbar-nav > li > a:hover {
            background-color: #0951a3 !important;
            color: white !important;
            transform: scale(1.15);
            border-radius: 15px;
        }
    </style>
    <script type="text/javascript">
        function openEmpDetail() {
            //alert("Opening modal!");
            $('#modEmpDetail').modal('show');
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="container">
            <%-- Nav Bar --%>
            <div class="navbar navbar-default">
                <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav" style="font-weight: bold;">
                            <li>
                                <asp:HyperLink ID="hlHome" NavigateUrl="~/Default.aspx" runat="server">Home</asp:HyperLink><br />
                            </li>
                            <li>
                                <asp:HyperLink ID="hlSuppliers" NavigateUrl="~/Suppliers.aspx" runat="server">Suppliers</asp:HyperLink><br />
                            </li>
                            <li>
                                <asp:HyperLink ID="hlEmployees" NavigateUrl="~/Employees.aspx" runat="server">Employees</asp:HyperLink><br />
                            </li>
                            <li>
                                <asp:HyperLink ID="hlCustomers" NavigateUrl="~/Customers.aspx" runat="server">Customers</asp:HyperLink><br />
                            </li>
                            <li>
                                <asp:HyperLink ID="hlCreditCards" NavigateUrl="~/CreditCards.aspx" runat="server">Credit Cards</asp:HyperLink><br />
                            </li>
                        </ul>
                    <div class="col-sm-4">
                        <asp:Label ID="lblMessage" runat="server" Text="" />
                    </div>
                    <div class="col-sm-14" style="text-align: right; margin-top: 30px;">
                        <asp:LinkButton ID="lbNewEmp" runat="server" Font-Size="16px" OnClick="lbNewEmp_Click" CssClass="btn btn-primary">Create New Employee</asp:LinkButton>
                    </div>
                </div>
            </div>

            <%-- Employees Heading 1--%>
            <div class="row">
                <div class="col-xs-12">
                    <h1>Employees</h1>
                </div>
            </div>


            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="EmpID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowDeleting="gvEmployees_RowDeleting"
                        OnRowCommand="gvEmployees_RowCommand"
                        EmptyDataText="No data for this request!">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="EmpID" HeaderText="Employee ID">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="EmpName" HeaderText="Employee Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="EmpEmail" HeaderText="Employee Email">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Department" HeaderText="Department">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="JobTitle" HeaderText="Job Title">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Salary" HeaderText="Salary">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>

                            <%-- Operations Column --%>
                            <asp:TemplateField HeaderText="Operations">
                                <HeaderStyle CssClass="text-center" />
                                <ItemTemplate>
                                    <%-- Update Employee --%>
                                    <asp:LinkButton ID="lbUpdEmployee" runat="server" CssClass="btn btn-primary btn-sm btn-success" CommandArgument='<%# Eval("EmpID") %>'
                                        CommandName="UpdEmployee" Text="Update" CausesValidation="false" style="font-weight: bold;"></asp:LinkButton>
                                    <%-- Delete Employee --%>
                                    <asp:LinkButton ID="lbDelEmployee" Text="Delete" runat="server" CssClass="btn btn-primary btn-danger btn-sm text-white"
                                        OnClientClick="return confirm('Are you sure you want to delete this employee?');" CommandName="Delete" style="margin-left: 6px; font-weight: bold;"/>                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="150px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Modal to Add New or View / Update a Employee Details-->
        <div class="modal fade" id="modEmpDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="lblEmployeeNew" runat="server" Text="Add New Employee" Font-Size="24px" Font-Bold="true" />
                        <asp:Label ID="lblEmployeeUpd" runat="server" Text="View / Update an Employee" Font-Size="24px" Font-Bold="true" />
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">

                                <%-- Employee Details Textboxes --%>
                                <div class="col-sm-12">
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtEmpName" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Employee Name"
                                                AutoCompleteType="Disabled" placeholder="Employee Name (e.g. John Doe)" />
                                            <asp:Label runat="server" ID="lblEmpID" Visible="false" Font-Size="12px" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtEmpEmail" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Employee Email"
                                                AutoCompleteType="Disabled" placeholder="Employee Email (e.g. john.doe@gmail.com)" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtDepartment" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Employee Department"
                                                AutoCompleteType="Disabled" placeholder="Employee Department (e.g. IT)" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtJobTitle" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Employee Job Title"
                                                AutoCompleteType="Disabled" placeholder="Employee Job Title (e.g. Programmer)" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtSalary" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Employee Salary"
                                                AutoCompleteType="Disabled" placeholder="Employee Salary (e.g. 5000)" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Message label on modal page --%>
                        <div class="row" style="margin-top: 20px; margin-bottom: 10px;">
                            <div class="col-sm-1"></div>
                            <div class="col-sm-10">
                                <asp:Label ID="lblModalMessage" runat="server" ForeColor="Red" Font-Size="12px" Text="" />
                            </div>
                            <div class="col-sm-1"></div>
                        </div>
                    </div>

                    <%-- Add, Update and Cancel Buttons --%>
                    <div class="modal-footer">
                        <asp:Button ID="btnAddEmployee" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Add Employee"
                            Visible="true" CausesValidation="false"
                            OnClick="btnAddEmployee_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnUpdEmployee" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Update Employee"
                            Visible="false" CausesValidation="false"
                            OnClick="btnUpdEmployee_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnClose" runat="server" class="btn btn-info button-xs" data-dismiss="modal" 
                            Text="Close" CausesValidation="false"
                            UseSubmitBehavior="false" />
                    </div>

                </div>
            </div>
        </div>

    </form>
</body>
</html>