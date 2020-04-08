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
using System.Globalization;

namespace mmgr
{
  public partial class frmMain : MetroFramework.Forms.MetroForm
  {
    //var globali della form
    public static SQLiteConnectionStringBuilder sqlite_connectString; //string x aprire il db
    public static SQLiteConnection sqlite_conn;       //connection to DB
    public static SQLiteCommand sqlite_cmd;           //command object
    public static SQLiteDataReader sqlite_datareader; // Data Reader Object
    //stringa per definizione lingua conversione formati numerici
    System.IFormatProvider cultureUS = new System.Globalization.CultureInfo("en-US");
    public frmMain()
    {
      InitializeComponent();
    }

    private void _openDB(string _pDBFname)
    {
      SQLiteConnectionStringBuilder sqlite_connectString = new SQLiteConnectionStringBuilder();
      sqlite_connectString.DataSource = _pDBFname;
      sqlite_connectString.DateTimeFormat = SQLiteDateFormats.CurrentCulture;

      // create a new database connection
      sqlite_conn = new SQLiteConnection(sqlite_connectString.ToString());

      //open the sqlite connection
      sqlite_conn.Open();
    }

    private void _closeDB(string _pDBFname)
    {
      //chiudo la connessione al db
      sqlite_conn.Close();
    }

    private void _createTreeMenu()
    {
      //creazione di tutto l'albero del menù
      treeMenu.Nodes.Clear();
      //area accounts
      TreeNode _accountHeadNode = new TreeNode("Accounts");
      treeMenu.Nodes.Add(_accountHeadNode);

      //if here are accounts in the DB i add the nodes to the tree
      if (sqlite_conn.State == ConnectionState.Open)
      {
        //
        frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
        frmMain.sqlite_cmd.CommandText = "SELECT * FROM DBACCOUNT ORDER BY ACCNAME";

        frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();

        while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
        {
          TreeNode _accountChildNode = new TreeNode(frmMain.sqlite_datareader["ACCNAME"].ToString());
          _accountChildNode.Tag = frmMain.sqlite_datareader["ACCID"].ToString();
          if (frmMain.sqlite_datareader["ACCTYPE"].ToString() == "Checking")
            _accountChildNode.StateImageKey = "account_bank.png";
          if (frmMain.sqlite_datareader["ACCTYPE"].ToString() == "Cash")
            _accountChildNode.StateImageKey = "account_cash.png";
          if (frmMain.sqlite_datareader["ACCTYPE"].ToString() == "CreditCard")
            _accountChildNode.StateImageKey = "account_creditcard.png";

          _accountHeadNode.Nodes.Add(_accountChildNode);
        }
        frmMain.sqlite_datareader.Close();
      }

      //DBConfig - configuration tables
      TreeNode _configHeadNode = new TreeNode("Config");
      treeMenu.Nodes.Add(_configHeadNode);
      TreeNode _configChildNode1 = new TreeNode("Categories");
      _configChildNode1.StateImageKey = "config_category.png";
      _configHeadNode.Nodes.Add(_configChildNode1);
      TreeNode _configChildNode2 = new TreeNode("Accounts");
      _configChildNode2.StateImageKey = "config_account.png";
      _configHeadNode.Nodes.Add(_configChildNode2);
      TreeNode _configChildNode3 = new TreeNode("Payees");
      _configChildNode3.StateImageKey = "config_payee.png";
      _configHeadNode.Nodes.Add(_configChildNode3);

      //reports
      TreeNode _reportHeadNode = new TreeNode("Reports");
      treeMenu.Nodes.Add(_reportHeadNode);
      TreeNode _reportChildNode1 = new TreeNode("Incoming Vs Expenses");
      _reportChildNode1.StateImageKey = "Chart_Bar.png";
      _reportHeadNode.Nodes.Add(_reportChildNode1);
      TreeNode _reportChildNode2 = new TreeNode("Monthly Category");
      _reportChildNode2.StateImageKey = "chart_report.png";
      _reportHeadNode.Nodes.Add(_reportChildNode2);

      treeMenu.ExpandAll();
    }

    private void _openChildLedgerForm(string _pAccountName)
    { //verfico che venga passato un parametro per l'apertura della form
      if (_pAccountName != "" && _pAccountName != "Accounts")
      {
        /*
        //verifico che non ci sia già una forma aperta
        bool _bValue = false;
        foreach (Form fm in this.MdiChildren)
        {
          if (fm.Text == "Ledger - " + _pAccountName)
          {
            fm.Activate();
            //fm.WindowState = FormWindowState.Maximized;
            _bValue = true;
          }
        }
        */

        //apertura della form 
        if (!_chkOpenForm("Ledger - " + _pAccountName))
        {
          FrmChildLedger objfrmMChild = new FrmChildLedger();
          objfrmMChild._AccountName = _pAccountName;
          objfrmMChild.Text = "Ledger - " + _pAccountName;
          objfrmMChild.MdiParent = this;
          objfrmMChild.Show();
        }

        //al ritorno dalla chiusura della form devo aggiornare il grafico
        _FillChart();
      }
    }

    private bool _chkOpenForm(string _pFormtext)
    { 
      //verifico che non ci sia già una forma aperta
      bool _bValue = false;
      foreach (Form fm in this.MdiChildren)
        if (fm.Text == _pFormtext)
          _bValue = true;
      return _bValue;
    }

    private void _FillChart()
    {
      //var per il conteggio dei valori
      Double _lTotal = 0;
      //clean chart
      chTotals.Series["Totals"].Points.Clear();

      //query totalizzazione account
      string _sqlText = " SELECT DBACCOUNT.ACCNAME,  Sum(TRANSACTIONS.TRNAMOUNT) AS Sum_TRNAMOUNT " +
        " FROM DBACCOUNT INNER JOIN TRANSACTIONS ON DBACCOUNT.ACCID = TRANSACTIONS.TRNACCOUNT " +
        " GROUP BY DBACCOUNT.ACCNAME " +
        " ORDER BY DBACCOUNT.ACCNAME";

      frmMain.sqlite_cmd = frmMain.sqlite_conn.CreateCommand();
      frmMain.sqlite_cmd.CommandText = _sqlText;
      frmMain.sqlite_datareader = frmMain.sqlite_cmd.ExecuteReader();
      if (frmMain.sqlite_datareader.HasRows)
        while (frmMain.sqlite_datareader.Read()) // Read() returns true if there is still a result line to read
        {
          if (frmMain.sqlite_datareader["Sum_TRNAMOUNT"].ToString() != "")
          {
            _lTotal = frmMain.sqlite_datareader.GetDouble(frmMain.sqlite_datareader.GetOrdinal("Sum_TRNAMOUNT"));
            chTotals.Series["Totals"].Points.AddXY(frmMain.sqlite_datareader["ACCNAME"].ToString(), _lTotal);
          }
        }
      frmMain.sqlite_datareader.Close();

    }

    private void FrmLedger_Load(object sender, EventArgs e)
    {
      //TODO: gestione file ini per salvare l'ultimo db

      //System.IO.Path.GetDirectoryName(Application.ExecutablePath.ToString()) + "\\dbone.db";
      //_openDB(@"C:\Users\rives\source\repos\mmgr\mmgr\dbone.db");

      _openDB(System.IO.Path.GetDirectoryName(Application.ExecutablePath.ToString()) + "\\dbone.db"); //apertura del db

      _createTreeMenu(); //caricamento del menù

      _FillChart(); //creazione grafico
    }

    private void treeMenu_KeyDown(object sender, KeyEventArgs e)
    {
      if (e.KeyCode == Keys.Enter)
        _evaluateMenuClick(treeMenu.SelectedNode);
    }

    private void treeMenu_DoubleClick(object sender, EventArgs e)
    {
      _evaluateMenuClick(treeMenu.SelectedNode);
    }

    private void _evaluateMenuClick(TreeNode _pNode)
    {
      //gestione dell'aerture delle varie form in base alla selezione del tree menu
      if (_pNode.FullPath.Contains("Accounts\\")) // apro i vari registri/ledger sugli accounts
        _openChildLedgerForm(_pNode.Text);

      if (_pNode.FullPath.Contains("Config\\Categories")) 
        if (!_chkOpenForm("Categories")) // apro la gestione delle categorie
        {
          frmDBCategories objfrmMChild = new frmDBCategories();
          objfrmMChild.Text = "Categories";
          objfrmMChild.MdiParent = this;
          objfrmMChild.Show();
        }
      if (_pNode.FullPath.Contains("Config\\Payees"))
        if (!_chkOpenForm("Payees")) // apro la gestione dei payee
        {
          frmDBPayees objfrmMChild = new frmDBPayees();
          objfrmMChild.Text = "Payees";
          objfrmMChild.MdiParent = this;
          objfrmMChild.Show();
        }

    }

  }
}
