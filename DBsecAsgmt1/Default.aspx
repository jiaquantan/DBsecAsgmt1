<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DBsecAsgmt1.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Assignment 1 Web Application</title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
    <style>
        .mr-3 {
            font-weight: bold
        }
        body {
            background-color: whitesmoke;
        }
        .navbar {
            background-color: antiquewhite;
            padding-top: 15px;
            padding-bottom: 15px;
        }
        .navbar-nav > li {
            margin-right: 15px; /* Increase the gap between navbar buttons */
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
</head>

<body>
    <form id="form1" runat="server">
        <div class="container">

            <%-- Webpage Heading and Menu --%>
            <div class="row">
                <div class="col-xs-12 d-flex align-items-center">
                    <h1 class="mr-3">Assignment 1 Enterprise Web Application</h1>
                    <div class="navbar navbar-default">
                        <div class="navbar-collapse collapse">
                            <ul class="nav navbar-nav" style="font-weight: bold;">
                                <li>
                                    <asp:HyperLink ID="hlHome" NavigateUrl="~/Default.aspx" runat="server">Home</asp:HyperLink>
                                </li>
                                <li>
                                    <asp:HyperLink ID="hlSuppliers" NavigateUrl="~/Suppliers.aspx" runat="server">Suppliers</asp:HyperLink>
                                </li>
                                <li>
                                    <asp:HyperLink ID="hlEmployees" NavigateUrl="~/Employees.aspx" runat="server">Employees</asp:HyperLink>
                                </li>
                                <li>
                                    <asp:HyperLink ID="hlCustomers" NavigateUrl="~/Customers.aspx" runat="server">Customers</asp:HyperLink>
                                </li>
                                <li>
                                    <asp:HyperLink ID="hlCreditCards" NavigateUrl="~/CreditCards.aspx" runat="server">Credit Cards</asp:HyperLink>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Message --%>
            <div class="row">
                <div class="col-xs-12">
                    <asp:Label ID="lblMessage" runat="server" Text="" class="navbar-text" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
