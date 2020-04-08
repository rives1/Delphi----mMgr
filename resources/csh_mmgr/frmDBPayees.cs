using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace mmgr
{
  public partial class frmDBPayees : MetroFramework.Forms.MetroForm
  {
    public frmDBPayees()
    {
      InitializeComponent();
    }

    private void frmDBPayees_Load(object sender, EventArgs e)
    {
      _loadTreeMenu();
    }

    public TreeNode _SearchTree(TreeNodeCollection nodes, string searchtext)
    {
      /* ciclo per la ricerca dei valori del TAG dei node
       * per ritornare l'ID del nodo
       */
      TreeNode _result = null;

      foreach (TreeNode node in nodes)
      {
        //31.12.18 -- if (node.Tag.ToString().Substring(1,node.Tag.ToString().Length-1) == searchtext)
        if (node.Tag.ToString() == searchtext) // 31.12.18 -- ricerca su tutta la stringa di ricerca es "C1" il primo carattere indica chesi stratta di una categoria 
          _result = node;
        //else
        TreeNode _result2 = _SearchTree(node.Nodes, searchtext);

        if (_result2 != null)
          _result = _result2;
      }

      return _result;
    }

    private void _loadTreeMenu()
    {
      //create the main categries tree
      treePayees.Nodes.Clear();

      //add payees
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM DBPAYEE ORDER BY PAYNAME";
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        TreeNode _accountChildNode = new TreeNode(frmMain.sqlite_datareader["PAYNAME"].ToString());
        _accountChildNode.Tag = frmMain.sqlite_datareader["PAYID"].ToString();
        treePayees.Nodes.Add(_accountChildNode);
        /*
                if (frmMain.sqlite_datareader["CATTYPE"].ToString() == "Incoming")
                  _accountHeadNodeINC.Nodes.Add(_accountChildNode);
                else
                  _accountHeadNodeEXP.Nodes.Add(_accountChildNode);
              }
              frmMain.sqlite_datareader.Close();

              //add subcategories to the tree
              frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
              frmMain.sqlite_cmd.CommandText = "SELECT * " +
                " FROM DBSUBCATEGORY " +
                " ORDER BY SUBCDES";
              frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();
              while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
              {
                TreeNode _accountChildNode = new TreeNode(frmMain.sqlite_datareader["SUBCDES"].ToString());
                _accountChildNode.Tag = "S" + frmMain.sqlite_datareader["SUBCID"].ToString();
                //cerco il nodo padre
                TreeNode tn = _SearchTree(treePayees.Nodes, "C" + frmMain.sqlite_datareader["SUBCATID"].ToString());
                tn.Nodes.Add(_accountChildNode);
              }
        */
      }
      frmMain.sqlite_datareader.Close();
      treePayees.ExpandAll();
    }

    private void _fillChartTotals()
    {
      //eseguo due query per definire i due dati delle serie da inserire nel chart
      Double _lTotal = 0;
      chHistory.Series["History"].Points.Clear();

      //qry calcolo per chart History
      string _sqlText = "SELECT StrfTime('%Y', TRNDATE) || \" - \" || StrfTime('%W', TRNDATE) AS Period, " +
                  " Sum(TRNAMOUNT) AS Sum_TRNAMOUNT " +
                  " FROM LedgerView " +
                  " WHERE PAYNAME = '" + treePayees.SelectedNode.Text + "'" +
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

    private void _cleanFields()
    {
      //ripulisco i campi della form
      edtName.Text = "";
      edtType.Text = "";
      edtID.Text = "";
    }

    private void _loadRecord(string _pID, string _table, string _IDfld)
    {
      //carico nella mask i dati del nodo visualizzato 
      //add categories
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM " + _table + " WHERE " + _IDfld + " = " + _pID;
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        edtID.Text = frmMain.sqlite_datareader["PAYID"].ToString();
        edtName.Text = frmMain.sqlite_datareader["PAYNAME"].ToString();
      }
      frmMain.sqlite_datareader.Close();
    }

    private void _editSavePayee(string _pEditType, string _pNodeID)
    {
      /* Edito o inserisco il record del Payee
       * Parametri:
       * _pEditType  - Edit - Edita il nodo selezionato
       * _pNodeID - id del nodo - necessario per l'aggiornmento
       * 
       */

      string _sqlQuery = ""; // var per la definzione della query da eseguire

      //creazione oggetto per esecuzione qry
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();

      if (_pEditType == "Edit")
      {
        //eseguo qry inserimento
        _sqlQuery = "UPDATE DBPAYEE SET" +
          " PAYNAME  = @pName " +
          " WHERE PAYID = @pID";
        frmMain.sqlite_cmd.Parameters.AddWithValue("@pName", edtName.Text);
        frmMain.sqlite_cmd.Parameters.AddWithValue("@pID", _pNodeID);
      }

      frmMain.sqlite_cmd.CommandText = _sqlQuery;
      //esecuzione della query
      try
      {
        frmMain.sqlite_cmd.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        throw new Exception(ex.Message);
      }
    }

    private void treePayees_MouseDoubleClick(object sender, MouseEventArgs e)
    {
      _fillChartTotals();
      _loadRecord(treePayees.SelectedNode.Tag.ToString(), "DBPAYEE", "PAYID");
      edtType.Text = "Edit";
    }

    private void btnOK_Click(object sender, EventArgs e)
    {
      if (edtName.Text != "") // il campo non deve essere vuoto
      {
        _editSavePayee(edtType.Text, edtID.Text);
        MessageBox.Show("Record updated!");
        _loadTreeMenu();
        _cleanFields();
      }

    }
  }
}
