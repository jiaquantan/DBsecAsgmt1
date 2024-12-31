using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DBsecAsgmt1
{
    public partial class Employees : System.Web.UI.Page
    {
        int Emp_ID;
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
                using (SqlCommand myCom = new SqlCommand("dbo.GetEmployees", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvEmployees.DataSource = myDr;
                    gvEmployees.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in loading Employees Table: " + ex.Message; }
            finally { myCon.Close(); }
        }

        protected void lbNewEmp_Click(object sender, EventArgs e)
        {
            try
            {
                txtEmpName.Text = "";
                txtEmpEmail.Text = "";
                txtDepartment.Text = "";
                txtJobTitle.Text = "";
                txtSalary.Text = "";

                lblEmployeeNew.Visible = true;
                lblEmployeeUpd.Visible = false;
                btnAddEmployee.Visible = true;
                btnUpdEmployee.Visible = false;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpDetail();", true);
            }
            catch (Exception) { throw; }
        }

        protected void btnAddEmployee_Click(object sender, EventArgs e)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.InsEmployee", myCon))
                {
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@EmpName", SqlDbType.NVarChar).Value = txtEmpName.Text;
                    myCom.Parameters.Add("@EmpEmail", SqlDbType.NVarChar).Value = txtEmpEmail.Text;
                    myCom.Parameters.Add("@Department", SqlDbType.NVarChar).Value = txtDepartment.Text;
                    myCom.Parameters.Add("@JobTitle", SqlDbType.NVarChar).Value = txtJobTitle.Text;
                    myCom.Parameters.Add("@Salary", SqlDbType.Int).Value = txtSalary.Text;

                    myCom.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in btnAddEmployee_Click: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        protected void btnUpdEmployee_Click(object sender, EventArgs e)
        {
            UpdEmployee();
            DoGridView();
        }

        protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdEmployee")
            {
                Emp_ID = Convert.ToInt32(e.CommandArgument);


                txtEmpName.Text = "";
                txtEmpEmail.Text = "";
                txtDepartment.Text = "";
                txtJobTitle.Text = "";
                txtSalary.Text = "";

                // Set modal to "Update Employee" mode
                lblEmployeeNew.Visible = false; // Hide "Add New Employee" label
                lblEmployeeUpd.Visible = true;  // Show "Update Employee" label
                btnAddEmployee.Visible = false; // Hide "Add" button
                btnUpdEmployee.Visible = true;  // Show "Update" button

                GetEmployee(Emp_ID);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpDetail();", true);
            }
        }

        protected void gvEmployees_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            Emp_ID = Convert.ToInt32(gvEmployees.DataKeys[e.RowIndex].Value.ToString());

            try
            {
                myCon.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.DelEmployee", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@EmpID", SqlDbType.Int).Value = Emp_ID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in gvEmployees_RowDeleting: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        private void GetEmployee(int Emp_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.GetEmployee", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@EmpID", SqlDbType.Int).Value = Emp_ID;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            txtEmpName.Text = myDr.GetValue(1).ToString();
                            txtEmpEmail.Text = myDr.GetValue(2).ToString();
                            txtDepartment.Text = myDr.GetValue(3).ToString();
                            txtJobTitle.Text = myDr.GetValue(4).ToString();
                            txtSalary.Text = myDr.GetValue(5).ToString();
                            lblEmpID.Text = Emp_ID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Employees GetEmployee: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void UpdEmployee()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.UpdEmployee", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Ensure lblEmpID.Text is a valid integer
                    if (int.TryParse(lblEmpID.Text, out int EmpID))
                    {
                        cmd.Parameters.Add("@EmpID", SqlDbType.Int).Value = EmpID;
                        cmd.Parameters.Add("@EmpName", SqlDbType.NVarChar).Value = txtEmpName.Text;
                        cmd.Parameters.Add("@EmpEmail", SqlDbType.NVarChar).Value = txtEmpEmail.Text;
                        cmd.Parameters.Add("@Department", SqlDbType.NVarChar).Value = txtDepartment.Text;
                        cmd.Parameters.Add("@JobTitle", SqlDbType.NVarChar).Value = txtJobTitle.Text;
                        cmd.Parameters.Add("@Salary", SqlDbType.Int).Value = txtSalary.Text;

                        int rows = cmd.ExecuteNonQuery();
                    }
                    else
                    {
                        lblMessage.Text = "Invalid Employee ID format";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error in Employees UpdEmployee: " + ex.Message;
            }
            finally { myCon.Close(); }
        }
    }
}