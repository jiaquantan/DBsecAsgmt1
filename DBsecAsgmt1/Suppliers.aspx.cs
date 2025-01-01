using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace DBsecAsgmt1
{
    public partial class Suppliers : System.Web.UI.Page
    {
        int SupplierID;
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
                using (SqlCommand myCom = new SqlCommand("dbo.GetSuppliers", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    SqlDataReader myDr = myCom.ExecuteReader();
                    gvSuppliers.DataSource = myDr;
                    gvSuppliers.DataBind();
                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Retrieving Suppliers Table: " + ex.Message; }
            finally { myCon.Close(); }
        }

        protected void lbNewSup_Click(object sender, EventArgs e)
        {
            try
            {
                txtSupplierName.Text = "";
                txtSupplierContactNo.Text = "";
                txtSupplierAddress.Text = "";
                txtSupplierEmail.Text = "";

                lblSupplierNew.Visible = true;
                lblSupplierUpd.Visible = false;
                btnAddSupplier.Visible = true;
                btnUpdSupplier.Visible = false;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openSupDetail();", true);
            }
            catch (Exception) { throw; }
        }

        protected void btnAddSupplier_Click(object sender, EventArgs e)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.InsSupplier", myCon))
                {
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@SupplierName", SqlDbType.NVarChar).Value = txtSupplierName.Text;
                    myCom.Parameters.Add("@SupplierContactNo", SqlDbType.NVarChar).Value = txtSupplierContactNo.Text;
                    myCom.Parameters.Add("@Address", SqlDbType.NVarChar).Value = txtSupplierAddress.Text;
                    myCom.Parameters.Add("@SupplierEmail", SqlDbType.NVarChar).Value = txtSupplierEmail.Text;
                    myCom.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Creating Supplier: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        protected void btnUpdSupplier_Click(object sender, EventArgs e)
        {
            UpdSupplier();
            DoGridView();
        }


        protected void gvSuppliers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdSupplier")
            {
                SupplierID = Convert.ToInt32(e.CommandArgument);

                txtSupplierName.Text = "";
                txtSupplierContactNo.Text = "";
                txtSupplierAddress.Text = "";
                txtSupplierEmail.Text = "";

                // Set modal to "Update Supplier" mode
                lblSupplierNew.Visible = false; // Hide "Add New Supplier" label
                lblSupplierUpd.Visible = true;  // Show "Update Supplier" label
                btnAddSupplier.Visible = false; // Hide "Add" button
                btnUpdSupplier.Visible = true;  // Show "Update" button

                GetSupplier(SupplierID);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openSupDetail();", true);
            }
        }

        protected void gvSuppliers_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            SupplierID = Convert.ToInt32(gvSuppliers.DataKeys[e.RowIndex].Value.ToString());
            
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.DelSupplier", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@SupplierID", SqlDbType.Int).Value = SupplierID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Deleting Supplier: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        private void GetSupplier(int SupplierID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.GetSupplier", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@SupplierID", SqlDbType.Int).Value = SupplierID;
                    SqlDataReader mydr = myCmd.ExecuteReader();
                    
                    if (mydr.HasRows)
                    {
                        while (mydr.Read())
                        {
                            txtSupplierName.Text = mydr.GetValue(1).ToString();
                            txtSupplierContactNo.Text = mydr.GetValue(2).ToString();
                            txtSupplierAddress.Text = mydr.GetValue(3).ToString();
                            txtSupplierEmail.Text = mydr.GetValue(4).ToString();
                            lblSupplierID.Text = SupplierID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Retrieving Supplier: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void UpdSupplier()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.UpdSupplier", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Ensure lblSupplierID.Text is a valid integer
                    if (int.TryParse(lblSupplierID.Text, out int SupplierID))
                    {
                        cmd.Parameters.Add("@SupplierID", SqlDbType.Int).Value = SupplierID;
                        cmd.Parameters.Add("@SupplierName", SqlDbType.NVarChar).Value = txtSupplierName.Text;
                        cmd.Parameters.Add("@SupplierContactNo", SqlDbType.NVarChar).Value = txtSupplierContactNo.Text;
                        cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = txtSupplierAddress.Text;
                        cmd.Parameters.Add("@SupplierEmail", SqlDbType.NVarChar).Value = txtSupplierEmail.Text;

                        int rows = cmd.ExecuteNonQuery();
                    }
                    else
                    {
                        lblMessage.Text = "Invalid Supplier ID format";
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Updating Supplier: " + ex.Message; }
            finally { myCon.Close(); }
        }
    }
}
