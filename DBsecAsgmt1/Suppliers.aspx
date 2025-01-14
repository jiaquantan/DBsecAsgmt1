﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Suppliers.aspx.cs" Inherits="DBsecAsgmt1.Suppliers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Suppliers</title>

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
            background-color: antiquewhite
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
        function openSupDetail() {
            $('#modSupDetail').modal('show');
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="container">

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
                    <asp:LinkButton ID="lbNewSup" runat="server" Font-Size="16px" OnClick="lbNewSup_Click" CssClass="btn btn-primary">Create New Supplier</asp:LinkButton>
                </div>
            </div>
            </div>

            <%-- Suppliers Heading 1 --%>
            <div class="row">
                <div class="col-xs-12">
                    <h1>Suppliers</h1>
                </div>
            </div>


            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvSuppliers" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="SupplierID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowDeleting="gvSuppliers_RowDeleting"
                        OnRowCommand="gvSuppliers_RowCommand"
                        EmptyDataText="No data for this request!">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="SupplierID" HeaderText="Supplier ID">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SupplierName" HeaderText="Supplier Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SupplierContactNo" HeaderText="Supplier Contact Number">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Address" HeaderText="Supplier Address">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SupplierEmail" HeaderText="Supplier Email">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>

                            <%-- Operations Column --%>
                            <asp:TemplateField HeaderText="Operations">
                                <HeaderStyle CssClass="text-center" />
                                <ItemTemplate>
                                    <%-- Update Supplier --%>
                                    <asp:LinkButton ID="lbUpdSupplier" runat="server" CssClass="btn btn-primary btn-sm btn-success" CommandArgument='<%# Eval("SupplierID") %>'
                                        CommandName="UpdSupplier" Text="Update" CausesValidation="false" style="font-weight: bold;"></asp:LinkButton>
                                    <%-- Delete Supplier --%>
                                    <asp:LinkButton ID="lbDelSupplier" Text="Delete" runat="server" CssClass="btn btn-primary btn-danger btn-sm text-white"
                                        OnClientClick="return confirm('Are you sure you want to delete this supplier?');" CommandName="Delete" style="margin-left: 6px; font-weight: bold;"/>                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="150px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Modal to Add New or View / Update a Supplier Details-->
        <div class="modal fade" id="modSupDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="lblSupplierNew" runat="server" Text="Add New Supplier" Font-Size="24px" Font-Bold="true" />
                        <asp:Label ID="lblSupplierUpd" runat="server" Text="View / Update a Supplier" Font-Size="24px" Font-Bold="true" />
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">

                                <%-- Supplier Details Textboxes --%>
                                <div class="col-sm-12">
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtSupplierName" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Supplier Name"
                                                AutoCompleteType="Disabled" placeholder="Supplier Name (e.g. Abc Sdn Bhd)" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtSupplierContactNo" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Supplier Contact Number"
                                                AutoCompleteType="Disabled" placeholder="Supplier Contact Number (e.g. 03-8888 9999)" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtSupplierAddress" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Supplier Address"
                                                AutoCompleteType="Disabled" placeholder="Supplier Address (e.g. Jalan Ampang, KL)" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtSupplierEmail" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Supplier Email"
                                                AutoCompleteType="Disabled" placeholder="Supplier Email (e.g. abc.gmail.com)" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <asp:Label runat="server" ID="lblSupplierID" Visible="false" Font-Size="12px" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <asp:Button ID="btnAddSupplier" runat="server" class="btn btn-danger" Text="Add Supplier" Visible="true"
                            OnClick="btnAddSupplier_Click" />
                        <asp:Button ID="btnUpdSupplier" runat="server" class="btn btn-danger" Text="Update Supplier" Visible="false"
                            OnClick="btnUpdSupplier_Click" />
                        <asp:Button ID="btnClose" runat="server" class="btn btn-info" Text="Close" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
