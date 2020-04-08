namespace mmgr
{
  partial class frmDBCategories
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null))
      {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmDBCategories));
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.treeCategories = new System.Windows.Forms.TreeView();
            this.metroContextMenu1 = new MetroFramework.Controls.MetroContextMenu(this.components);
            this.addCategoryToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.addSubCategoryToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.editNodeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.edtID = new MetroFramework.Controls.MetroTextBox();
            this.edtType = new MetroFramework.Controls.MetroTextBox();
            this.btnOK = new MetroFramework.Controls.MetroTile();
            this.lblCategory = new MetroFramework.Controls.MetroLabel();
            this.metroLabel2 = new MetroFramework.Controls.MetroLabel();
            this.metroLabel1 = new MetroFramework.Controls.MetroLabel();
            this.edtDescription = new MetroFramework.Controls.MetroTextBox();
            this.cmbSubcat = new MetroFramework.Controls.MetroComboBox();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.metroContextMenu1.SuspendLayout();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(20, 60);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.treeCategories);
            this.splitContainer1.Panel1.Padding = new System.Windows.Forms.Padding(5);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.splitContainer1.Panel2.Controls.Add(this.edtID);
            this.splitContainer1.Panel2.Controls.Add(this.edtType);
            this.splitContainer1.Panel2.Controls.Add(this.btnOK);
            this.splitContainer1.Panel2.Controls.Add(this.lblCategory);
            this.splitContainer1.Panel2.Controls.Add(this.metroLabel2);
            this.splitContainer1.Panel2.Controls.Add(this.metroLabel1);
            this.splitContainer1.Panel2.Controls.Add(this.edtDescription);
            this.splitContainer1.Panel2.Controls.Add(this.cmbSubcat);
            this.splitContainer1.Size = new System.Drawing.Size(725, 419);
            this.splitContainer1.SplitterDistance = 198;
            this.splitContainer1.TabIndex = 0;
            // 
            // treeCategories
            // 
            this.treeCategories.BackColor = System.Drawing.Color.Gray;
            this.treeCategories.ContextMenuStrip = this.metroContextMenu1;
            this.treeCategories.Dock = System.Windows.Forms.DockStyle.Fill;
            this.treeCategories.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.treeCategories.Location = new System.Drawing.Point(5, 5);
            this.treeCategories.Margin = new System.Windows.Forms.Padding(5);
            this.treeCategories.Name = "treeCategories";
            this.treeCategories.Size = new System.Drawing.Size(188, 409);
            this.treeCategories.TabIndex = 0;
            this.treeCategories.BeforeCollapse += new System.Windows.Forms.TreeViewCancelEventHandler(this.treeCategories_BeforeCollapse);
            this.treeCategories.DoubleClick += new System.EventHandler(this.treeCategories_DoubleClick);
            // 
            // metroContextMenu1
            // 
            this.metroContextMenu1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.addCategoryToolStripMenuItem,
            this.addSubCategoryToolStripMenuItem,
            this.toolStripSeparator1,
            this.editNodeToolStripMenuItem});
            this.metroContextMenu1.Name = "metroContextMenu1";
            this.metroContextMenu1.Size = new System.Drawing.Size(166, 76);
            // 
            // addCategoryToolStripMenuItem
            // 
            this.addCategoryToolStripMenuItem.Name = "addCategoryToolStripMenuItem";
            this.addCategoryToolStripMenuItem.Size = new System.Drawing.Size(165, 22);
            this.addCategoryToolStripMenuItem.Text = "Add Category";
            this.addCategoryToolStripMenuItem.Click += new System.EventHandler(this.addCategoryToolStripMenuItem_Click);
            // 
            // addSubCategoryToolStripMenuItem
            // 
            this.addSubCategoryToolStripMenuItem.Name = "addSubCategoryToolStripMenuItem";
            this.addSubCategoryToolStripMenuItem.Size = new System.Drawing.Size(165, 22);
            this.addSubCategoryToolStripMenuItem.Text = "Add Subcategory";
            this.addSubCategoryToolStripMenuItem.Click += new System.EventHandler(this.addSubCategoryToolStripMenuItem_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(162, 6);
            // 
            // editNodeToolStripMenuItem
            // 
            this.editNodeToolStripMenuItem.Name = "editNodeToolStripMenuItem";
            this.editNodeToolStripMenuItem.Size = new System.Drawing.Size(165, 22);
            this.editNodeToolStripMenuItem.Text = "Edit Node";
            this.editNodeToolStripMenuItem.Click += new System.EventHandler(this.editNodeToolStripMenuItem_Click);
            // 
            // edtID
            // 
            // 
            // 
            // 
            this.edtID.CustomButton.Image = null;
            this.edtID.CustomButton.Location = new System.Drawing.Point(8, 1);
            this.edtID.CustomButton.Name = "";
            this.edtID.CustomButton.Size = new System.Drawing.Size(27, 27);
            this.edtID.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
            this.edtID.CustomButton.TabIndex = 1;
            this.edtID.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
            this.edtID.CustomButton.UseSelectable = true;
            this.edtID.CustomButton.Visible = false;
            this.edtID.Enabled = false;
            this.edtID.FontSize = MetroFramework.MetroTextBoxSize.Medium;
            this.edtID.Lines = new string[0];
            this.edtID.Location = new System.Drawing.Point(39, 13);
            this.edtID.MaxLength = 32767;
            this.edtID.Multiline = true;
            this.edtID.Name = "edtID";
            this.edtID.PasswordChar = '\0';
            this.edtID.ReadOnly = true;
            this.edtID.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.edtID.SelectedText = "";
            this.edtID.SelectionLength = 0;
            this.edtID.SelectionStart = 0;
            this.edtID.ShortcutsEnabled = true;
            this.edtID.Size = new System.Drawing.Size(36, 29);
            this.edtID.TabIndex = 11;
            this.edtID.TabStop = false;
            this.edtID.UseSelectable = true;
            this.edtID.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.edtID.WaterMarkFont = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            // 
            // edtType
            // 
            // 
            // 
            // 
            this.edtType.CustomButton.Image = null;
            this.edtType.CustomButton.Location = new System.Drawing.Point(73, 1);
            this.edtType.CustomButton.Name = "";
            this.edtType.CustomButton.Size = new System.Drawing.Size(27, 27);
            this.edtType.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
            this.edtType.CustomButton.TabIndex = 1;
            this.edtType.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
            this.edtType.CustomButton.UseSelectable = true;
            this.edtType.CustomButton.Visible = false;
            this.edtType.Enabled = false;
            this.edtType.FontSize = MetroFramework.MetroTextBoxSize.Medium;
            this.edtType.Lines = new string[0];
            this.edtType.Location = new System.Drawing.Point(326, 13);
            this.edtType.MaxLength = 32767;
            this.edtType.Multiline = true;
            this.edtType.Name = "edtType";
            this.edtType.PasswordChar = '\0';
            this.edtType.ReadOnly = true;
            this.edtType.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.edtType.SelectedText = "";
            this.edtType.SelectionLength = 0;
            this.edtType.SelectionStart = 0;
            this.edtType.ShortcutsEnabled = true;
            this.edtType.Size = new System.Drawing.Size(101, 29);
            this.edtType.TabIndex = 11;
            this.edtType.TabStop = false;
            this.edtType.UseSelectable = true;
            this.edtType.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.edtType.WaterMarkFont = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            // 
            // btnOK
            // 
            this.btnOK.ActiveControl = null;
            this.btnOK.Enabled = false;
            this.btnOK.Location = new System.Drawing.Point(316, 328);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(107, 42);
            this.btnOK.TabIndex = 10;
            this.btnOK.Text = "Insert/Update";
            this.btnOK.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.btnOK.UseSelectable = true;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // lblCategory
            // 
            this.lblCategory.AutoSize = true;
            this.lblCategory.Location = new System.Drawing.Point(90, 17);
            this.lblCategory.Name = "lblCategory";
            this.lblCategory.Size = new System.Drawing.Size(15, 19);
            this.lblCategory.TabIndex = 9;
            this.lblCategory.Text = "-";
            // 
            // metroLabel2
            // 
            this.metroLabel2.AutoSize = true;
            this.metroLabel2.Location = new System.Drawing.Point(39, 139);
            this.metroLabel2.Name = "metroLabel2";
            this.metroLabel2.Size = new System.Drawing.Size(36, 19);
            this.metroLabel2.TabIndex = 9;
            this.metroLabel2.Text = "Type";
            // 
            // metroLabel1
            // 
            this.metroLabel1.AutoSize = true;
            this.metroLabel1.Location = new System.Drawing.Point(39, 55);
            this.metroLabel1.Name = "metroLabel1";
            this.metroLabel1.Size = new System.Drawing.Size(74, 19);
            this.metroLabel1.TabIndex = 8;
            this.metroLabel1.Text = "Description";
            // 
            // edtDescription
            // 
            // 
            // 
            // 
            this.edtDescription.CustomButton.Image = null;
            this.edtDescription.CustomButton.Location = new System.Drawing.Point(356, 1);
            this.edtDescription.CustomButton.Name = "";
            this.edtDescription.CustomButton.Size = new System.Drawing.Size(27, 27);
            this.edtDescription.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
            this.edtDescription.CustomButton.TabIndex = 1;
            this.edtDescription.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
            this.edtDescription.CustomButton.UseSelectable = true;
            this.edtDescription.CustomButton.Visible = false;
            this.edtDescription.FontSize = MetroFramework.MetroTextBoxSize.Medium;
            this.edtDescription.Lines = new string[0];
            this.edtDescription.Location = new System.Drawing.Point(39, 86);
            this.edtDescription.MaxLength = 32767;
            this.edtDescription.Multiline = true;
            this.edtDescription.Name = "edtDescription";
            this.edtDescription.PasswordChar = '\0';
            this.edtDescription.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.edtDescription.SelectedText = "";
            this.edtDescription.SelectionLength = 0;
            this.edtDescription.SelectionStart = 0;
            this.edtDescription.ShortcutsEnabled = true;
            this.edtDescription.Size = new System.Drawing.Size(384, 29);
            this.edtDescription.TabIndex = 7;
            this.edtDescription.UseSelectable = true;
            this.edtDescription.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.edtDescription.WaterMarkFont = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            // 
            // cmbSubcat
            // 
            this.cmbSubcat.FormattingEnabled = true;
            this.cmbSubcat.ItemHeight = 23;
            this.cmbSubcat.Items.AddRange(new object[] {
            "Expense",
            "Income"});
            this.cmbSubcat.Location = new System.Drawing.Point(39, 171);
            this.cmbSubcat.Margin = new System.Windows.Forms.Padding(2);
            this.cmbSubcat.Name = "cmbSubcat";
            this.cmbSubcat.Size = new System.Drawing.Size(143, 29);
            this.cmbSubcat.TabIndex = 6;
            this.cmbSubcat.UseSelectable = true;
            // 
            // imageList1
            // 
            this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "cat_deposit.ico");
            this.imageList1.Images.SetKeyName(1, "cat_expense.ico");
            // 
            // frmDBCategories
            // 
            this.AcceptButton = this.btnOK;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(765, 499);
            this.Controls.Add(this.splitContainer1);
            this.MaximizeBox = false;
            this.Name = "frmDBCategories";
            this.Text = "Categories";
            this.TransparencyKey = System.Drawing.Color.LightBlue;
            this.Load += new System.EventHandler(this.frmDBCategories_Load);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.metroContextMenu1.ResumeLayout(false);
            this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.SplitContainer splitContainer1;
    private System.Windows.Forms.TreeView treeCategories;
    private MetroFramework.Controls.MetroTextBox edtDescription;
    private MetroFramework.Controls.MetroComboBox cmbSubcat;
    private System.Windows.Forms.ImageList imageList1;
    private MetroFramework.Controls.MetroContextMenu metroContextMenu1;
    private System.Windows.Forms.ToolStripMenuItem addCategoryToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem addSubCategoryToolStripMenuItem;
    private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
    private System.Windows.Forms.ToolStripMenuItem editNodeToolStripMenuItem;
    private MetroFramework.Controls.MetroLabel metroLabel2;
    private MetroFramework.Controls.MetroLabel metroLabel1;
    private MetroFramework.Controls.MetroTile btnOK;
    private MetroFramework.Controls.MetroTextBox edtType;
    private MetroFramework.Controls.MetroLabel lblCategory;
    private MetroFramework.Controls.MetroTextBox edtID;
  }
}