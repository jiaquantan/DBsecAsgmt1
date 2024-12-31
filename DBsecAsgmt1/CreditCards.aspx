<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditCards.aspx.cs" Inherits="DBsecAsgmt1.CreditCards" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Credit Cards</title>

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
            function openCardDetail() {
                $('#modCardDetail').modal('show');
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
                            <asp:LinkButton ID="lbNewCard" runat="server" Font-Size="16px" OnClick="lbNewCard_Click" CssClass="btn btn-primary">Create New Card</asp:LinkButton>
                        </div>
                    </div>
                </div>

                 <%-- Credit Cards Heading 1 --%>
                <div class="row">
                    <div class="col-xs-12">
                        <h1>Credit Cards</h1>
                    </div>
                </div>

                <%-- Gridview --%>
                <div class="row" style="margin-top: 20px;">
                    <div class="col-sm-12">
                        <asp:GridView ID="gvCreditCards" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                            DataKeyNames="CardID"
                            CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                            OnRowDeleting="gvCreditCards_RowDeleting"
                            OnRowCommand="gvCreditCards_RowCommand"
                            EmptyDataText="No data for this request!">

                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="CardID" HeaderText="Card ID">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CardType" HeaderText="Card Type">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CardNumber" HeaderText="Card Number">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ExpMonth" HeaderText="Expiry Month">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ExpYear" HeaderText="Expiry Year">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CustID" HeaderText="Customer ID">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>

                            <%-- Operations Column --%>
                            <asp:TemplateField HeaderText="Operations">
                                <HeaderStyle CssClass="text-center" />
                                <ItemTemplate>
                                    <%-- Update Card --%>
                                    <asp:LinkButton ID="lbUpdCard" runat="server" CssClass="btn btn-primary btn-sm btn-success" CommandArgument='<%# Eval("CardID") %>'
                                        CommandName="UpdCard" Text="Update" CausesValidation="false" style="font-weight: bold;"></asp:LinkButton>
                                    <%-- Delete Card --%>
                                    <asp:LinkButton ID="lbDelCard" Text="Delete" runat="server" CssClass="btn btn-primary btn-danger btn-sm text-white"
                                        OnClientClick="return confirm('Are you sure you want to delete this card?');" CommandName="Delete" style="margin-left: 6px; font-weight: bold;"/>                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="150px" />
                            </asp:TemplateField>
                        </Columns>
                </asp:GridView>
                </div>
            </div>
        </div>

            <!-- Modal to Add New or View / Update a Card Details-->
            <div class="modal fade" id="modCardDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" style="width: 600px;">
                    <div class="modal-content" style="font-size: 11px;">

                        <div class="modal-header" style="text-align: center;">
                            <asp:Label ID="lblCardNew" runat="server" Text="Add New Card" Font-Size="24px" Font-Bold="true" />
                            <asp:Label ID="lblCardUpd" runat="server" Text="View / Update a Card" Font-Size="24px" Font-Bold="true" />
                        </div>

                        <div class="modal-body">
                            <div class="row">
                                <div class="col-sm-12">

                                    <%-- Credit Card Details Textboxes --%>
                                    <div class="col-sm-12">
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-10">
                                                <asp:TextBox ID="txtCardType" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Card Type"
                                                    AutoCompleteType="Disabled" placeholder="Card Type (e.g. Visa)" />
                                                <asp:Label runat="server" ID="lblCreditCardID" Visible="false" Font-Size="12px" />
                                            </div>
                                            <div class="col-sm-1"></div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-10">
                                                <asp:TextBox ID="txtCardNumber" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Card Number"
                                                    AutoCompleteType="Disabled" placeholder="Card Number (e.g. 111122223333)" />
                                            </div>
                                            <div class="col-sm-1"></div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-10">
                                                <asp:TextBox ID="txtExpMonth" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Expiry Month"
                                                    AutoCompleteType="Disabled" placeholder="Expiry Month (e.g. 12)" />
                                            </div>
                                            <div class="col-sm-1"></div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-10">
                                                <asp:TextBox ID="txtExpYear" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Expiry Year"
                                                    AutoCompleteType="Disabled" placeholder="Expiry Year (e.g. 2025)" />
                                            </div>
                                            <div class="col-sm-1"></div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-10">
                                                <asp:TextBox ID="txtCustID" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Customer ID"
                                                    AutoCompleteType="Disabled" placeholder="Customer ID (e.g. 301)" />
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
                            <asp:Button ID="btnAddCard" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                                Text="Add Card"
                                Visible="true" CausesValidation="false"
                                OnClick="btnAddCard_Click"
                                UseSubmitBehavior="false" />
                            <asp:Button ID="btnUpdCard" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                                Text="Update Card"
                                Visible="false" CausesValidation="false"
                                OnClick="btnUpdCreditCard_Click"
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
