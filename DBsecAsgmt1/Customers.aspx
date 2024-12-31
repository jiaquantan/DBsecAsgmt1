<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Customers.aspx.cs" Inherits="DBsecAsgmt1.Customers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customers</title>

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
        function openCustDetail() {
            //alert("Opening modal!");
            $('#modCustDetail').modal('show');
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
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
                        <asp:LinkButton ID="lbNewCust" runat="server" Font-Size="16px" OnClick="lbNewCust_Click" CssClass="btn btn-primary">Create New Customer</asp:LinkButton>
                    </div>
                </div>
            </div>

            <%-- Customers Heading 1 --%>
            <div class="row">
                <div class="col-xs-12">
                    <h1>Customers</h1>
                </div>
            </div>

            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="CustID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowDeleting="gvCustomers_RowDeleting"
                        OnRowCommand="gvCustomers_RowCommand"
                        EmptyDataText="No data for this request!">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="CustID" HeaderText="Customer ID">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CustName" HeaderText="Customer Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CustEmail" HeaderText="Customer Email">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CustContactNo" HeaderText="Customer Contact Number">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CustAddress" HeaderText="Customer Address">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>

                            <%-- Operations Column --%>
                            <asp:TemplateField HeaderText="Operations">
                                <HeaderStyle CssClass="text-center" />
                                <ItemTemplate>
                                    <%-- Update Customer --%>
                                    <asp:LinkButton ID="lbUpdCustomer" runat="server" CssClass="btn btn-primary btn-sm btn-success" CommandArgument='<%# Eval("CustID") %>'
                                        CommandName="UpdCustomer" Text="Update" CausesValidation="false" style="font-weight: bold;"></asp:LinkButton>
                                    <%-- Delete Customer --%>
                                    <asp:LinkButton ID="lbDelCustomer" Text="Delete" runat="server" CssClass="btn btn-primary btn-danger btn-sm text-white"
                                        OnClientClick="return confirm('Are you sure you want to delete this customer?');" CommandName="Delete" style="margin-left: 6px; font-weight: bold;"/>                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="150px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Modal to Add New or View / Update a Customer Details-->
        <div class="modal fade" id="modCustDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="lblCustomerNew" runat="server" Text="Add New Customer" Font-Size="24px" Font-Bold="true" />
                        <asp:Label ID="lblCustomerUpd" runat="server" Text="View / Update a Customer" Font-Size="24px" Font-Bold="true" />
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">

                                <%-- Customer Details Textboxes --%>
                                <div class="col-sm-12">
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtCustName" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Customer Name"
                                                AutoCompleteType="Disabled" placeholder="Customer Name (e.g. John Doe)" />
                                            <asp:Label runat="server" ID="lblCustID" Visible="false" Font-Size="12px" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtCustEmail" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Customer Email"
                                                AutoCompleteType="Disabled" placeholder="Customer Email (e.g. johndoe@gmail.com)" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtCustContactNo" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Customer Contact Number"
                                                AutoCompleteType="Disabled" placeholder="Customer Contact Number (e.g. 0123456789)" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtCustAddress" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Customer Address"
                                                AutoCompleteType="Disabled" placeholder="Customer Address (e.g. Jalan Ampang, KL)" />
                                        </div>
                                        <div class="col-sm-1"></div>
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
                        <asp:Button ID="btnAddCustomer" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Add Customer"
                            Visible="true" CausesValidation="false"
                            OnClick="btnAddCustomer_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnUpdCustomer" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Update Customer"
                            Visible="false" CausesValidation="false"
                            OnClick="btnUpdCustomer_Click"
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