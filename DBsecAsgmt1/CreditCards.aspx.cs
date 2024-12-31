using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DBsecAsgmt1
{
    public partial class CreditCards : System.Web.UI.Page
    {
        int Card_ID;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["AsgmtDBConnection"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCreditCards();
            }
        }

        private void LoadCreditCards()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.GetCreditCards", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    SqlDataReader myDr = cmd.ExecuteReader();

                    gvCreditCards.DataSource = myDr;
                    gvCreditCards.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error in loading Credit Cards Table: " + ex.Message;
            }
            finally
            {
                myCon.Close();
            }
        }

        protected void lbNewCard_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear the fields in the modal
                txtCardType.Text = "";
                txtCardNumber.Text = "";
                txtExpMonth.Text = "";
                txtExpYear.Text = "";
                txtCustID.Text = "";

                // Set modal to "Add" mode
                lblCardNew.Visible = true;
                lblCardUpd.Visible = false;
                btnAddCard.Visible = true;
                btnUpdCard.Visible = false;

                // Open the modal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openCardDetail();", true);
            }
            catch (Exception) { throw; }
        }


        protected void btnAddCard_Click(object sender, EventArgs e)
        {
            if (!ValidateInputs())
            {
                lblModalMessage.Text = "Please fill in all required fields.";
                return;
            }

            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.InsCreditCard", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@CardType", SqlDbType.NVarChar).Value = txtCardType.Text;
                    cmd.Parameters.Add("@CardNumber", SqlDbType.NVarChar).Value = txtCardNumber.Text;
                    cmd.Parameters.Add("@ExpMonth", SqlDbType.Int).Value = txtExpMonth.Text;
                    cmd.Parameters.Add("@ExpYear", SqlDbType.Int).Value = txtExpYear.Text;
                    cmd.Parameters.Add("@CustID", SqlDbType.Int).Value = txtCustID.Text;
                    
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                lblModalMessage.Text = "Error adding card: " + ex.Message;
            }
            finally
            {
                myCon.Close();
            }
            LoadCreditCards();
        }

        protected void btnUpdCreditCard_Click(object sender, EventArgs e)
        {
            UpdCreditCard();
            LoadCreditCards();
        }

        private void UpdCreditCard()
        {
            if (!ValidateInputs())
            {
                lblModalMessage.Text = "Please fill in all required fields.";
                return;
            }

            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.UpdCreditCard", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Ensure lblCustID.Text is a valid integer
                    if (int.TryParse(lblCreditCardID.Text, out int CardID))
                    {
                        cmd.Parameters.Add("@CardID", SqlDbType.Int).Value = CardID;
                        cmd.Parameters.Add("@CardType", SqlDbType.NVarChar).Value = txtCardType.Text;
                        cmd.Parameters.Add("@CardNumber", SqlDbType.NVarChar).Value = txtCardNumber.Text;
                        cmd.Parameters.Add("@ExpMonth", SqlDbType.Int).Value = txtExpMonth.Text;
                        cmd.Parameters.Add("@ExpYear", SqlDbType.Int).Value = txtExpYear.Text;
                        cmd.Parameters.Add("@CustID", SqlDbType.Int).Value = txtCustID.Text;

                        int rows = cmd.ExecuteNonQuery();
                    }
                    else
                    {
                        lblMessage.Text = "Invalid Credit Card ID format";
                    }
                }
            }
            catch (Exception ex)
            {
                lblModalMessage.Text = "Error updating card: " + ex.Message;
            }
            finally
            {
                myCon.Close();
            }
        }


        protected void gvCreditCards_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdCreditCard")
            {
                Card_ID = Convert.ToInt32(e.CommandArgument);

                // Clear the fields in the modal
                txtCardType.Text = "";
                txtCardNumber.Text = "";
                txtExpMonth.Text = "";
                txtExpYear.Text = "";
                txtCustID.Text = "";

                // Set modal to "Update" mode
                lblCardNew.Visible = false;
                lblCardUpd.Visible = true;
                btnAddCard.Visible = false;
                btnUpdCard.Visible = true;

                GetCard(Card_ID);

                // Open modal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openCardDetail();", true);
            }
        }
        protected void gvCreditCards_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            Card_ID = Convert.ToInt32(gvCreditCards.DataKeys[e.RowIndex].Value);
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.DelCreditCard", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@CardID", SqlDbType.Int).Value = Card_ID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error deleting card: " + ex.Message;
            }
            finally
            {
                myCon.Close();
            }
            LoadCreditCards();
        }

        private void GetCard(int Card_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.GetCreditCard", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@CardID", SqlDbType.Int).Value = Card_ID;
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            txtCardType.Text = dr["CardType"].ToString();
                            txtCardNumber.Text = dr["CardNumber"].ToString();
                            txtExpMonth.Text = dr["ExpMonth"].ToString();
                            txtExpYear.Text = dr["ExpYear"].ToString();
                            txtCustID.Text = dr["CustID"].ToString();
                            lblCreditCardID.Text = Card_ID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error retrieving card details: " + ex.Message;
            }
            finally
            {
                myCon.Close();
            }
        }

        private bool ValidateInputs()
        {
            return !string.IsNullOrWhiteSpace(txtCardType.Text) &&
                   !string.IsNullOrWhiteSpace(txtCardNumber.Text) &&
                   !string.IsNullOrWhiteSpace(txtExpMonth.Text) &&
                   !string.IsNullOrWhiteSpace(txtExpYear.Text) &&
                   !string.IsNullOrWhiteSpace(txtCustID.Text);
        }
    }
}