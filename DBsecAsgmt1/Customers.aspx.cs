﻿using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DBsecAsgmt1
{
    public partial class Customers : System.Web.UI.Page
    {
        int Cust_ID;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["AsgmtDBConnection"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DoGridView();
            }
        }

        private void DoGridView()
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.GetCustomers", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvCustomers.DataSource = myDr;
                    gvCustomers.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Customers doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }

        protected void lbNewCust_Click(object sender, EventArgs e)
        {
            try
            {
                txtCustName.Text = "";
                txtCustEmail.Text = "";
                txtCustAddress.Text = "";
                txtCustContactNo.Text = "";

                lblCustomerNew.Visible = true;
                lblCustomerUpd.Visible = false;
                btnAddCustomer.Visible = true;
                btnUpdCustomer.Visible = false;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openCoDetail();", true);
            }
            catch (Exception) { throw; }
        }

        protected void btnAddCustomer_Click(object sender, EventArgs e)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.InsCustomer", myCon))
                {
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@CustomerName", SqlDbType.VarChar).Value = txtCustName.Text;
                    myCom.Parameters.Add("@CustomerAddress", SqlDbType.VarChar).Value = txtCustAddress.Text;
                    myCom.Parameters.Add("@CustomerContactNo", SqlDbType.VarChar).Value = txtCustContactNo.Text;

                    myCom.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in btnAddCustomer_Click: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        protected void btnUpdCustomer_Click(object sender, EventArgs e)
        {
            UpdCustomer();
            DoGridView();
        }

        protected void gvCustomers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdCustomer")
            {
                Cust_ID = Convert.ToInt32(e.CommandArgument);


                txtCustName.Text = "";
                txtCustAddress.Text = "";
                txtCustContactNo.Text = "";

                lblCustomerNew.Visible = false;
                lblCustomerUpd.Visible = true;
                btnAddCustomer.Visible = false;
                btnUpdCustomer.Visible = true;

                GetCustomer(Cust_ID);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openCoDetail();", true);
            }
        }

        protected void gvCustomers_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            Cust_ID = Convert.ToInt32(gvCustomers.DataKeys[e.RowIndex].Value.ToString());

            try
            {
                myCon.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.DelCustomer", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = Cust_ID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in gvCustomers_RowDeleting: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        private void GetCustomer(int Cust_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.GetCustomer", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@ID", SqlDbType.Int).Value = Cust_ID;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            txtCustName.Text = myDr.GetValue(1).ToString();
                            txtCustAddress.Text = myDr.GetValue(2).ToString();
                            txtCustContactNo.Text = myDr.GetValue(3).ToString();
                            lblCustID.Text = Cust_ID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Customers GetCompany: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void UpdCustomer()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.UpdCustomer", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = int.Parse(lblCustID.Text);
                    cmd.Parameters.Add("@CompanyName", SqlDbType.VarChar).Value = txtCustName.Text;
                    cmd.Parameters.Add("@CompAddress", SqlDbType.VarChar).Value = txtCustAddress.Text;
                    cmd.Parameters.Add("@CompContactNo", SqlDbType.VarChar).Value = txtCustContactNo.Text;


                    int rows = cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Customers UpdCustomer: " + ex.Message; }
            finally { myCon.Close(); }
        }
    }
}