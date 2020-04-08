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
  public partial class FrmChildLedger : MetroFramework.Forms.MetroForm
  {
    public FrmChildLedger()
    {
      InitializeComponent();
    }

    private string _pIDLedger = string.Empty;

    public string _AccountName
    {
      get
      { return _pIDLedger; }
      set
      { _pIDLedger = value; }
    }

    private void _openEditForm(string _pEditkind)
    {
      frmModalRecord objfrmMChild = new frmModalRecord();
      objfrmMChild._AccountName = this._AccountName; //nome dell'account da utilizzare 
      objfrmMChild._InserType = _pEditkind; //definizione se il record è in editing se nuovo o se nuovo deposito o nuova spesa
      if ((_pEditkind == "Edit") && (dtGrd.RowCount > 0))  //se edit invio l'ID del record
        objfrmMChild._EditID = int.Parse(dtGrd.Rows[dtGrd.CurrentCell.RowIndex].Cells[0].Value.ToString()); //define the record ID to be edited
      else
        objfrmMChild._EditID = 0;

      objfrmMChild.ShowDialog(); //apro la mask in modale
      
      //refresh della grid
      _fillGrid();
      _fillChartTotals();
    }

    private void _fillGrid()
    {
      double _lRunsum = 0; //running sum

      //recupero dati tabella
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM LedgerView where ACCNAME = '" + _AccountName + "' ORDER BY TRNDATE";

      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      //pulisco il dataset della grid
      dSet.Tables["tblTransaction"].Clear();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        DataRow anyRow = dSet.Tables["tblTransaction"].NewRow();

        anyRow["trnID"] = frmMain.sqlite_datareader["TRNID"].ToString();
        anyRow["trnType"] = frmMain.sqlite_datareader["TRNTYPE"].ToString();
        anyRow["trnDate"] = Convert.ToDateTime(frmMain.sqlite_datareader["TRNDATE"]).ToShortDateString();
        anyRow["trnPayee"] = frmMain.sqlite_datareader["PAYNAME"].ToString();
        anyRow["trnCategory"] = frmMain.sqlite_datareader["CATDES"].ToString();
        if (frmMain.sqlite_datareader["SUBCDES"].ToString() != "")
        { anyRow["trnCategory"] += ": " + frmMain.sqlite_datareader["SUBCDES"].ToString(); }
        anyRow["trnDes"] = frmMain.sqlite_datareader["TRNDESCRIPTION"].ToString();
        //decisione in quale casella mettere la cifra
        if (frmMain.sqlite_datareader.GetDouble(frmMain.sqlite_datareader.GetOrdinal("TRNAMOUNT")) >= 0)
          anyRow["trnAmountIN"] = frmMain.sqlite_datareader["TRNAMOUNT"].ToString();
        else
          anyRow["trnAmountOut"] = frmMain.sqlite_datareader["TRNAMOUNT"].ToString();
        //calc running sum
        _lRunsum += frmMain.sqlite_datareader.GetDouble(frmMain.sqlite_datareader.GetOrdinal("TRNAMOUNT"));
        anyRow["trnrunningSum"] = _lRunsum.ToString();

        /*
         if (frmMain.sqlite_datareader["TRNTYPE"].ToString() == "Pay")
          anyRow["trnAmountOut"] = frmMain.sqlite_datareader["TRNAMOUNT"].ToString();
        if (frmMain.sqlite_datareader["TRNTYPE"].ToString() == "Deposit")
          anyRow["trnAmountIN"] = frmMain.sqlite_datareader["TRNAMOUNT"].ToString();
        */

        //aggiungo la riga alla tabella
        dSet.Tables[0].Rows.Add(anyRow);
      }
      frmMain.sqlite_datareader.Close();
      //spostarsi all'ultima riga della grid
      dtGrd.CurrentCell = dtGrd[1, dtGrd.Rows.Count - 1];
      
    }

    private void _fillChartTotals()
    {
      //eseguo due query per definire i due dati delle serie da inserire nel chart
      Double _lTotal = 0;
      //clean chart
      chTotals.Series["Totals"].Points.Clear();
      //query totalizzazione depositi
      string _sqlText = "SELECT Sum(TRNAMOUNT) AS Sum_TRNAMOUNT " +
        " FROM LedgerView " +
        " WHERE " +
        " TRNAMOUNT > 0 " +
        " AND ACCNAME = '" + _AccountName + "'" +
        " ORDER BY ACCNAME"; ;
      
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = _sqlText;
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();
      if (frmMain.sqlite_datareader.HasRows)
        while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
        {
          if (frmMain.sqlite_datareader["Sum_TRNAMOUNT"].ToString() != "")
          {
            _lTotal = frmMain.sqlite_datareader.GetDouble(frmMain.sqlite_datareader.GetOrdinal("Sum_TRNAMOUNT"));
            chTotals.Series["Totals"].Points.AddXY("Deposit", _lTotal);
          }
        }

      frmMain.sqlite_datareader.Close();

      //qry totalizzazione spese
      _sqlText = "SELECT Sum(TRNAMOUNT) AS Sum_TRNAMOUNT " +
      " FROM LedgerView " +
      " WHERE " +
      " TRNAMOUNT < 0 " +
      " AND ACCNAME = '" + _AccountName + "'";
      frmMain.sqlite_cmd.CommandText = _sqlText;
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();
      if (frmMain.sqlite_datareader.HasRows)
        while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
        {
          if (frmMain.sqlite_datareader["Sum_TRNAMOUNT"].ToString() != "")
          { 
            _lTotal = _lTotal + frmMain.sqlite_datareader.GetDouble(frmMain.sqlite_datareader.GetOrdinal("Sum_TRNAMOUNT"));
            chTotals.Series["Totals"].Points.AddXY("Expense", frmMain.sqlite_datareader.GetDouble(frmMain.sqlite_datareader.GetOrdinal("Sum_TRNAMOUNT")));
          }
        }

      chTotals.Titles["chTitle"].Text = "Balance: " + _lTotal.ToString("N2");
      frmMain.sqlite_datareader.Close();

      //qry calcolo per chart History
      _lTotal = 0;
      chHistory.Series["History"].Points.Clear();
      _sqlText = "SELECT StrfTime('%Y', TRNDATE) || \" - \" || StrfTime('%W', TRNDATE) AS Period, " +
                  " Sum(TRNAMOUNT) AS Sum_TRNAMOUNT " +
                  " FROM LedgerView " +
                  " WHERE ACCNAME = '" + _AccountName + "'" + 
                  " GROUP BY Period " +
                  " ORDER BY StrfTime('%Y', TRNDATE) || \" - \" || StrfTime('%W', TRNDATE)";  

      frmMain.sqlite_cmd.CommandText = _sqlText;
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();
      if (frmMain.sqlite_datareader.HasRows)
        while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
        {
          if (frmMain.sqlite_datareader["Sum_TRNAMOUNT"].ToString() != "")
          {
            _lTotal += frmMain.sqlite_datareader.GetDouble(frmMain.sqlite_datareader.GetOrdinal("Sum_TRNAMOUNT"));
            chHistory.Series["History"].Points.AddXY(frmMain.sqlite_datareader.GetString(frmMain.sqlite_datareader.GetOrdinal("Period")), _lTotal);
          }
        }
      frmMain.sqlite_datareader.Close();
    }

    private void _deleteRecord()
    {
      if (MessageBox.Show("Confirm Deletion?", "ATTENTION", MessageBoxButtons.YesNo) == DialogResult.Yes)
      {
        //string for query
        string _sqlQuery = "";

        //frmMain.sqlite_conn.CreateCommand();
        SQLiteCommand sqlite_runsql = frmMain.sqlite_conn.CreateCommand();

        _sqlQuery = "DELETE FROM TRANSACTIONS WHERE TRNID = @pID ";
        //get the parameter from the id of the record in the grid
        sqlite_runsql.Parameters.AddWithValue("@pID", int.Parse(dtGrd.Rows[dtGrd.CurrentCell.RowIndex].Cells[0].Value.ToString()));

        //create the command 
        sqlite_runsql.CommandText = _sqlQuery;

        try
        {
          sqlite_runsql.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
          throw new Exception(ex.Message);
        }

        //refresh della grid
        _fillGrid();
        _fillChartTotals();
      }
    }

    private void FrmChildLedger_Load(object sender, EventArgs e)
    {
      _fillGrid();
      _fillChartTotals();
    }

    private void FrmChildLedger_KeyDown(object sender, KeyEventArgs e)
    {
      if (e.KeyCode == Keys.Insert)
        _openEditForm("New");
      if (e.KeyCode == Keys.Add)
        _openEditForm("NewDeposit");
      if (e.KeyCode == Keys.Subtract)
        _openEditForm("NewExpense");
      if (e.KeyCode == Keys.Enter)
       _openEditForm("Edit");
      if (e.KeyCode == Keys.Delete)
        _deleteRecord();
      if (e.KeyCode == Keys.Escape)
        if (MessageBox.Show("Close the Ledger?", "ATTENTION", MessageBoxButtons.YesNo) == DialogResult.Yes)
          this.Close();

    }

    private void dtGrd_DoubleClick(object sender, EventArgs e)
    {
       _openEditForm("Edit");
    }


  }
}
