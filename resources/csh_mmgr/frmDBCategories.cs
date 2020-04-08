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
  public partial class frmDBCategories : MetroFramework.Forms.MetroForm
  {
    public frmDBCategories()
    {
      InitializeComponent();
    }

    private void frmDBCategories_Load(object sender, EventArgs e)
    {
      _createTreeMenu();
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

    private void _createTreeMenu()
    {
      //create the main categries tree
      treeCategories.Nodes.Clear();

      //area accounts
      TreeNode _accountHeadNodeEXP = new TreeNode("Expenses");
      _accountHeadNodeEXP.Tag = "H"; //identifica il ramo header
      treeCategories.Nodes.Add(_accountHeadNodeEXP);

      TreeNode _accountHeadNodeINC = new TreeNode("Incoming");
      _accountHeadNodeINC.Tag = "H"; //identifica il ramo header
      treeCategories.Nodes.Add(_accountHeadNodeINC);

      //add categories
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM DBCATEGORY ORDER BY CATDES";
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        TreeNode _accountChildNode = new TreeNode(frmMain.sqlite_datareader["CATDES"].ToString());
        _accountChildNode.Tag = "C" + frmMain.sqlite_datareader["CATID"].ToString(); //identifica il ramo come categoria
        if (frmMain.sqlite_datareader["CATTYPE"].ToString() == "Income")
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
        TreeNode tn = _SearchTree(treeCategories.Nodes, "C" + frmMain.sqlite_datareader["SUBCATID"].ToString());
        tn.Nodes.Add(_accountChildNode);
      }
      frmMain.sqlite_datareader.Close();

      treeCategories.ExpandAll();
    }

    private void _cleanFields()
    {
      //ripulisco i campi della form
      edtDescription.Text = "";
      cmbSubcat.Text = "";
      edtType.Text = "";
      edtID.Text = "";
      lblCategory.Text = "";
    }

    private void _loadRecord(string _pID, string _table, string _IDfld)
    {
      //carico nella mask i dati del nodo visualizzato 
      //add categories
      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = "SELECT * FROM " + _table + " WHERE "+_IDfld +" = " + _pID;
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

      while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
      {
        if (_table == "DBCATEGORY")
        {
          edtID.Text = frmMain.sqlite_datareader["CATID"].ToString();
          edtDescription.Text = frmMain.sqlite_datareader["CATDES"].ToString();
          cmbSubcat.Text = frmMain.sqlite_datareader["CATTYPE"].ToString();
          cmbSubcat.Enabled = true;
        }
        else // in this case table is SUBCATEGORY
        {
          edtID.Text = frmMain.sqlite_datareader["SUBCID"].ToString();
          edtDescription.Text = frmMain.sqlite_datareader["SUBCDES"].ToString();
          lblCategory.Text = frmMain.sqlite_datareader["SUBCATID"].ToString();
          cmbSubcat.Text = "";
          cmbSubcat.Enabled = false;
        }
      }
      frmMain.sqlite_datareader.Close();
    }

    private void _editInsCategory(string _pEditType, string _pNodeID)
    {
      /* Edito o inserisco il record della categoria / subcategoria
       * Parametri:
       * _pCatName - descrizione
       * _pEditType  - InsCat - inserisce una categoria 
       *             - InsSub - inserisce una sottocategoria al nodo selezionato
       *             - EditCat - Edita il nodo selezionato
       *             - EditSub - Edita sottocategoria
       *             
       * _pNodeID - id del nodo - necessario per l'aggiornmento
       * 
       */

      string _sqlQuery = ""; // var per la definzione della query da eseguire

      //creazione oggetto per esecuzione qry
      SQLiteCommand sqlite_runsql = frmMain.sqlite_conn.CreateCommand();

      if (_pEditType == "InsCat")
      {
        //stringa per inserimento categoria
        _sqlQuery = "INSERT INTO DBCATEGORY(CATDES, CATTYPE)" +
                    " VALUES (@pDes, @pType)";
        sqlite_runsql.Parameters.AddWithValue("@pDes", edtDescription.Text);
        sqlite_runsql.Parameters.AddWithValue("@pType", cmbSubcat.Text);
      }

      if (_pEditType == "InsSub")
      {
        //string per isnerimento sottocategoria
        _sqlQuery = "INSERT INTO DBSUBCATEGORY(SUBCATID, SUBCDES)" +
                    " VALUES (@pCatID, @pSubcdes)";
        sqlite_runsql.Parameters.AddWithValue("@pCatID", lblCategory.Text);
        sqlite_runsql.Parameters.AddWithValue("@pSubcdes", cmbSubcat.Text);
      }

      if (_pEditType == "EditCat")
      {
        //eseguo qry inserimento
        _sqlQuery = "UPDATE DBCATEGORY SET" +
          " CATDES  = @pDes," +
          " CATTYPE = @pType " +
          " WHERE CATID = @pID";
        sqlite_runsql.Parameters.AddWithValue("@pDes", edtDescription.Text);
        sqlite_runsql.Parameters.AddWithValue("@pType", cmbSubcat.Text);
        sqlite_runsql.Parameters.AddWithValue("@pID", _pNodeID);
      }

      if (_pEditType == "EditSub")
      {
        //eseguo qry inserimento
        _sqlQuery = "UPDATE DBSUBCATEGORY SET" +
          " SUBCDES  = @pDes," +
          " SUBCATID = @pSubcatID " +
          " WHERE SUBCID = @pID";
        sqlite_runsql.Parameters.AddWithValue("@pDes", edtDescription.Text);
        sqlite_runsql.Parameters.AddWithValue("@pSubcatID", lblCategory.Text);
        sqlite_runsql.Parameters.AddWithValue("@pID", _pNodeID);
      }

      sqlite_runsql.CommandText = _sqlQuery;
      //esecuzione della query
      try
      {
        sqlite_runsql.ExecuteNonQuery();
      }
      catch (Exception ex)
      {
        throw new Exception(ex.Message);
      }
    }

    private void _evaluateTreeviewtoLoadrecord(string _pInsEdit)
    {
      //procedo alla configurazione dei campi della mask
      _cleanFields();
      btnOK.Enabled = true;
      edtType.Text = _pInsEdit;

      if (_pInsEdit == "Edit")
      {
        if (treeCategories.SelectedNode.Tag.ToString().Substring(0, 1) == "C")  // categoria
        { 
          _loadRecord(treeCategories.SelectedNode.Tag.ToString().Substring(1, treeCategories.SelectedNode.Tag.ToString().Length - 1), "DBCATEGORY", "CATID");
          edtType.Text = "EditCat";
          cmbSubcat.Visible = true;
        }
        if (treeCategories.SelectedNode.Tag.ToString().Substring(0, 1) == "S")  // sottocategoria
        {
          _loadRecord(treeCategories.SelectedNode.Tag.ToString().Substring(1, treeCategories.SelectedNode.Tag.ToString().Length - 1), "DBSUBCATEGORY", "SUBCID");
          edtType.Text = "EditSub";
          cmbSubcat.Visible = false;
        }
        if (treeCategories.SelectedNode.Tag.ToString().Substring(0, 1) == "H")  // header
          MessageBox.Show("impossible to edit the main groups!!!!");
      }

      edtDescription.Focus();
    }

    private void editNodeToolStripMenuItem_Click(object sender, EventArgs e)
    {
      lblCategory.Text = treeCategories.SelectedNode.Tag.ToString().Substring(1, treeCategories.SelectedNode.Tag.ToString().Length - 1);
      _evaluateTreeviewtoLoadrecord("Edit");
    }

    private void addCategoryToolStripMenuItem_Click(object sender, EventArgs e)
    {
      _evaluateTreeviewtoLoadrecord("InsCat");
    }

    private void addSubCategoryToolStripMenuItem_Click(object sender, EventArgs e)
    {
      lblCategory.Text = treeCategories.SelectedNode.Tag.ToString().Substring(1, treeCategories.SelectedNode.Tag.ToString().Length - 1);
      _evaluateTreeviewtoLoadrecord("InsSub");
    }

    private void btnOK_Click(object sender, EventArgs e)
    {
      _editInsCategory(edtType.Text,treeCategories.SelectedNode.Tag.ToString().Substring(1, treeCategories.SelectedNode.Tag.ToString().Length - 1));
      _createTreeMenu();
      MessageBox.Show("Operation completed");
      _cleanFields();
    }

    private void treeCategories_DoubleClick(object sender, EventArgs e)
    {
      lblCategory.Text = treeCategories.SelectedNode.Tag.ToString();
      _evaluateTreeviewtoLoadrecord("Edit");
    }

    private void treeCategories_BeforeCollapse(object sender, TreeViewCancelEventArgs e)
    {
      //evito che i nodi collassino
      e.Cancel = true; 
    }

  } //public partial class

}
