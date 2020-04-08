using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SQLite;

namespace mmgr
{
  public partial class frmModalRecord : MetroFramework.Forms.MetroForm
    {
    public frmModalRecord()
    {
      InitializeComponent();
    }
    //properties
    private int _pEditID; //defines whic is the ID of the record in case of record editing
    private string _pIDLedger = string.Empty; //properties for account ID
    private string _pInsertType = string.Empty; //properties to define if the new record is expense->"NewExpense" or a deposit->"NewDeposit"

    public int _EditID //property ID record
    {
      get
      { return _pEditID; }
      set
      { _pEditID = value; }
    }

    public int _getDBID(string _pTBL, string _pIDfld, string _pDESfld, string _pParam)
    {
      int _retval = 0;
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT " + _pIDfld + " FROM " + _pTBL + " where " + _pDESfld + " = '" + _pParam + "'";
      SQLiteDataReader loc_sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      while (loc_sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        // System.Console.WriteLine("DEBUG Output: '" + sqlite_datareader["text"] + "'");
        _retval = int.Parse(loc_sqlite_datareader[_pIDfld].ToString());
      }
      loc_sqlite_datareader.Close();

      return _retval;
    }

    public string _AccountName // property account
    {
      get
      { return _pIDLedger; }
      set
      { _pIDLedger = value; }
    }

    public string _InserType // property account
    {
      //get
      //{ return _pInsertType; }
      set
      { _pInsertType = value; }
    }

    public string _FormatAmount(string _pAmount)
    {
      double _tRetval = double.Parse(_pAmount);

      if(lbType.Text == "Pay")
        _tRetval = _tRetval * -1;

      return _tRetval.ToString().Replace(",", ".");

      //TODO parte da eliminare perchè non usata - controllare

      /*//considero sempre la cifra inserita come comprensiva dei decimali
      if (_pAmount.IndexOf(",") == -1)
      {
        //TODO: verificare nel caso il valore sia < di 2 digit
        if (_pAmount.Length >= 2)
          _pAmount = _pAmount.Substring(0, _pAmount.Length - 2) +
                     "," +
                      _pAmount.Substring(_pAmount.Length - 2, 2);
        else
          _pAmount = "0." + _pAmount;
      }
      double _tRetval = double.Parse(_pAmount);

      //return string.Format("{0:0.00}", double.Parse(_pAmount));
      return _tRetval.ToString("N2");
      */
    }

    private void _loadCmbPayee()
    {
      //payee
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM DBPAYEE";
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      cmbPayee.Items.Clear();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
        cmbPayee.Items.Add(frmMain.sqlite_datareader["PAYNAME"].ToString());

      frmMain.sqlite_datareader.Close();
    }
   
    private void _loadCmbCategory()
    {
      //categoria
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM DBCATEGORY";
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      cmbCategory.Items.Clear();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        cmbCategory.Items.Add(frmMain.sqlite_datareader["CATDES"].ToString());
      }
      frmMain.sqlite_datareader.Close();
    }

    private void _loadCmbSubcategory()
    {
      //subcategoria
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT DBSUBCATEGORY.* FROM DBCATEGORY INNER JOIN DBSUBCATEGORY ON DBCATEGORY.CATID = DBSUBCATEGORY.SUBCATID " +
      " WHERE DBCATEGORY.CATDES = '" + cmbCategory.Text + "'";

      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      cmbSubcat.Items.Clear();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        cmbSubcat.Items.Add(frmMain.sqlite_datareader["SUBCDES"].ToString());
      }

      frmMain.sqlite_datareader.Close();
    }

    private void frmModalRecord_Load(object sender, EventArgs e)
    {
      //fill combobox data
      _loadCmbPayee();
      _loadCmbCategory();

      if (_pInsertType == "NewDeposit")
        lbType.Text = "Deposit";

      if (_pInsertType == "NewExpense")
        lbType.Text = "Pay";

      //if the record is edited
      if (_EditID != 0) 
        _recordLoad();
    }

    private void frmModalRecord_KeyPress(object sender, KeyPressEventArgs e)
    {
      //save the data
//      if (e.KeyChar == (char)13) //save record
//      {  _recordSave();   }

      if (e.KeyChar == (char)27) //ESC close the form
      {
        if (MessageBox.Show("Close the record without saving?", "ATTENTION", MessageBoxButtons.YesNo) == DialogResult.Yes)
          this.Close();
      }
    }

    private void _chkPayeeEsistence()
    {
      //se il cavlore inserito nella cobo payee non è presente nell'elenco della stessa aggiungo il record nella tabella payee
      if (cmbPayee.Items.IndexOf(cmbPayee.Text.ToUpper()) == -1)
      {
        //inserisco il valore nella tabella dei payee
        string _sqlQuery = "";

        //frmMain.sqlite_conn.CreateCommand();
        SQLiteCommand sqlite_runsql = frmMain.sqlite_conn.CreateCommand();
        _sqlQuery = "INSERT INTO DBPAYEE (PAYNAME) " +
          " VALUES(@pPayName)";
        sqlite_runsql.Parameters.AddWithValue("@pPayName", cmbPayee.Text.ToUpper());

        sqlite_runsql.CommandText = _sqlQuery;
        try
        {
          sqlite_runsql.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
          throw new Exception(ex.Message);
        }
      }
    }

    private void _recordLoad()
    {
      //string _tmpfield = "";

      //load fields with data
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM LedgerView where TRNID = " + _EditID;
      SQLiteDataReader loc_sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      while (loc_sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        //fill data fields on mask
        edtID.Text = _EditID.ToString();
        lbType.Text = loc_sqlite_datareader["TRNTYPE"].ToString();
        dtData.Value = Convert.ToDateTime(loc_sqlite_datareader["TRNDATE"]);
        cmbPayee.Text = loc_sqlite_datareader["PAYNAME"].ToString();
        cmbCategory.Text = loc_sqlite_datareader["CATDES"].ToString();
        cmbSubcat.Text = loc_sqlite_datareader["SUBCDES"].ToString();
        edtDescription.Text = loc_sqlite_datareader["TRNDESCRIPTION"].ToString();
        edtAmount.Text = Math.Abs(loc_sqlite_datareader.GetDouble(loc_sqlite_datareader.GetOrdinal("TRNAMOUNT"))).ToString();
      }

      //chiuso il reader
      loc_sqlite_datareader.Close();
    }

    private bool _fieldValidation()
    {
      //verfiico che i campi siano compilati
      bool _retval = true;

      if (lbType.Text == "" || edtAmount.Text == "" || cmbPayee.Text == "" || cmbCategory.Text == "") 
        _retval = false;

      //ritorno il valore
      return _retval;
    }

    private void _recordSave()
    {
      //string for query
      string _sqlQuery = "";

      //frmMain.sqlite_conn.CreateCommand();
      SQLiteCommand sqlite_runsql = frmMain.sqlite_conn.CreateCommand();

      if (_EditID == 0) // insert new record
      {
        _sqlQuery = "INSERT INTO TRANSACTIONS (TRNTYPE, TRNDATE, TRNPAYEE, TRNCATEGORY, TRNSUBCATEGORY, TRNAMOUNT, TRNACCOUNT, TRNDESCRIPTION) " +
                    " VALUES (@pType, @pDate, @pPayee, @pCategory, @pSubcat, @pAmount, @pAccount, @pDes)";
      }
      else //update record
      {
        _sqlQuery = "UPDATE TRANSACTIONS SET TRNTYPE = @pType, " +
          " TRNDATE = datetime(@pDate), " +
          " TRNPAYEE = @pPayee, " +
          " TRNCATEGORY = @pCategory, " +
          " TRNSUBCATEGORY = @pSubcat, " +
          " TRNAMOUNT = @pAmount, " +
          " TRNACCOUNT = @pAccount, " +
          " TRNDESCRIPTION = @pDes " +
          " WHERE TRNID = @pID ";

        /*
        _sqlQuery = "UPDATE TRANSACTIONS SET TRNTYPE = '" + lbType.Text + "'" +
        ", TRNDATE = datetime('" + dtData.Value.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture) + "')" +
        ", TRNPAYEE = " + _getDBID("DBPAYEE", "PAYID", "PAYNAME", cmbPayee.Text) +
        ", TRNCATEGORY = " + _getDBID("DBCATEGORY", "CATID", "CATDES", cmbCategory.Text) +
        ", TRNSUBCATEGORY = " + _getDBID("DBSUBCATEGORY", "SUBCID", "SUBCDES", cmbSubcat.Text) +
        ", TRNAMOUNT = " + edtAmount.Text.Replace(",", ".") +
        ", TRNACCOUNT = " + _getDBID("DBACCOUNT", "ACCID", "ACCNAME", this._AccountName) +
        ", TRNDESCRIPTION = '" + edtDescription.Text + "'"+
        " WHERE TRNID = " + edtID.Text;
        */

        sqlite_runsql.Parameters.AddWithValue("@pID", edtID.Text);
      }

      //create the command and set parameters
      sqlite_runsql.CommandText = _sqlQuery;
      sqlite_runsql.Parameters.AddWithValue("@pType", lbType.Text);
      sqlite_runsql.Parameters.AddWithValue("@pDate", dtData.Value.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture));
      sqlite_runsql.Parameters.AddWithValue("@pPayee", _getDBID("DBPAYEE", "PAYID", "PAYNAME", cmbPayee.Text.ToUpper()));
      sqlite_runsql.Parameters.AddWithValue("@pCategory", _getDBID("DBCATEGORY", "CATID", "CATDES", cmbCategory.Text));
      sqlite_runsql.Parameters.AddWithValue("@pSubcat", _getDBID("DBSUBCATEGORY", "SUBCID", "SUBCDES", cmbSubcat.Text));
      sqlite_runsql.Parameters.AddWithValue("@pAmount", _FormatAmount(edtAmount.Text));
      sqlite_runsql.Parameters.AddWithValue("@pAccount", _getDBID("DBACCOUNT", "ACCID", "ACCNAME", this._AccountName));
      sqlite_runsql.Parameters.AddWithValue("@pDes", edtDescription.Text);

      try
      {
        sqlite_runsql.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        throw new Exception(ex.Message);
      }

      //chiudo la finestra
      this.Close();
    }

    private void _getRecentData()
    {
      /*if exiting the field(and it's a new record) there is a value in the combo i look for the latest data coming 
       * with that payee and propose the following fields
       * category
       * subcategory
       * description
       * amount
       */
      if (edtID.Text == "" && cmbPayee.Text !="") //if it's not editing a previous record
      {
        frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
          frmMain.sqlite_cmd.CommandText = " SELECT LedgerView.CATDES, LedgerView.SUBCDES, LedgerView.TRNDESCRIPTION, LedgerView.TRNAMOUNT " +
          " FROM LedgerView " +
          " WHERE LedgerView.PAYNAME = '" + cmbPayee.Text + "'" +
          " ORDER BY LedgerView.TRNDATE DESC ";
        SQLiteDataReader loc_sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

        // if i find a record the DESC order shows me the most recent for the payee
        if (loc_sqlite_datareader.Read()) // Read() returns true if there is still a result line to read - if to find the first record
        {
          // System.Console.WriteLine("DEBUG Output: '" + sqlite_datareader["text"] + "'");
          cmbCategory.Text = loc_sqlite_datareader["CATDES"].ToString();
          cmbSubcat.Text = loc_sqlite_datareader["SUBCDES"].ToString();
          edtDescription.Text = loc_sqlite_datareader["TRNDESCRIPTION"].ToString();
          edtAmount.Text = Math.Abs(loc_sqlite_datareader.GetDouble(loc_sqlite_datareader.GetOrdinal("TRNAMOUNT"))).ToString();
        }
        loc_sqlite_datareader.Close();
      }
    }

    private void cmbCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        //aggiorno i datit della subcategory
        _loadCmbSubcategory();
    }

    private void btnOK_Click(object sender, EventArgs e)
    {
      if (_fieldValidation())
      { 
        _chkPayeeEsistence();
        _recordSave();
      }
      else
        MessageBox.Show("Mandatory fields not entered!!!");
    }

    private void cmbPayee_Validating(object sender, CancelEventArgs e)
    {
      //verfico che il valore sia selezionato fra quelli presenti e recupero le info dei dati + recenti
      if (cmbPayee.Items.IndexOf(cmbPayee.Text.ToUpper()) > -1)
        _getRecentData();
    }

    private void frmModalRecord_Validating(object sender, CancelEventArgs e)
    {
      //verifico che i campi siano compilati prima di poter salvare il record
      if (lbType.Text == "") e.Cancel = true;
      if (edtAmount.Text == "") e.Cancel = true;

    }
  }
}
