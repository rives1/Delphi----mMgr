namespace mmgr
{
  partial class frmModalRecord
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
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmModalRecord));
      this.metroLabel1 = new MetroFramework.Controls.MetroLabel();
      this.cmbCategory = new MetroFramework.Controls.MetroComboBox();
      this.dtData = new MetroFramework.Controls.MetroDateTime();
      this.metroLabel2 = new MetroFramework.Controls.MetroLabel();
      this.metroLabel3 = new MetroFramework.Controls.MetroLabel();
      this.metroLabel4 = new MetroFramework.Controls.MetroLabel();
      this.metroLabel5 = new MetroFramework.Controls.MetroLabel();
      this.metroLabel6 = new MetroFramework.Controls.MetroLabel();
      this.cmbSubcat = new MetroFramework.Controls.MetroComboBox();
      this.edtDescription = new MetroFramework.Controls.MetroTextBox();
      this.edtAmount = new MetroFramework.Controls.MetroTextBox();
      this.edtID = new MetroFramework.Controls.MetroTextBox();
      this.btnOK = new MetroFramework.Controls.MetroTile();
      this.lbType = new MetroFramework.Controls.MetroComboBox();
      this.cmbPayee = new System.Windows.Forms.ComboBox();
      this.SuspendLayout();
      // 
      // metroLabel1
      // 
      this.metroLabel1.AutoSize = true;
      this.metroLabel1.Location = new System.Drawing.Point(42, 83);
      this.metroLabel1.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
      this.metroLabel1.Name = "metroLabel1";
      this.metroLabel1.Size = new System.Drawing.Size(36, 19);
      this.metroLabel1.TabIndex = 12;
      this.metroLabel1.Text = "Type";
      // 
      // cmbCategory
      // 
      this.cmbCategory.FlatStyle = System.Windows.Forms.FlatStyle.System;
      this.cmbCategory.ForeColor = System.Drawing.SystemColors.WindowText;
      this.cmbCategory.FormattingEnabled = true;
      this.cmbCategory.ItemHeight = 23;
      this.cmbCategory.Location = new System.Drawing.Point(141, 159);
      this.cmbCategory.Margin = new System.Windows.Forms.Padding(2);
      this.cmbCategory.Name = "cmbCategory";
      this.cmbCategory.Size = new System.Drawing.Size(223, 29);
      this.cmbCategory.Style = MetroFramework.MetroColorStyle.Blue;
      this.cmbCategory.TabIndex = 4;
      this.cmbCategory.UseSelectable = true;
      this.cmbCategory.SelectedIndexChanged += new System.EventHandler(this.cmbCategory_SelectedIndexChanged);
      // 
      // dtData
      // 
      this.dtData.DisplayFocus = true;
      this.dtData.Format = System.Windows.Forms.DateTimePickerFormat.Short;
      this.dtData.Location = new System.Drawing.Point(438, 73);
      this.dtData.Margin = new System.Windows.Forms.Padding(2);
      this.dtData.MinimumSize = new System.Drawing.Size(0, 29);
      this.dtData.Name = "dtData";
      this.dtData.Size = new System.Drawing.Size(114, 29);
      this.dtData.TabIndex = 2;
      // 
      // metroLabel2
      // 
      this.metroLabel2.AutoSize = true;
      this.metroLabel2.Location = new System.Drawing.Point(391, 83);
      this.metroLabel2.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
      this.metroLabel2.Name = "metroLabel2";
      this.metroLabel2.Size = new System.Drawing.Size(36, 19);
      this.metroLabel2.TabIndex = 12;
      this.metroLabel2.Text = "Data";
      // 
      // metroLabel3
      // 
      this.metroLabel3.AutoSize = true;
      this.metroLabel3.Location = new System.Drawing.Point(42, 125);
      this.metroLabel3.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
      this.metroLabel3.Name = "metroLabel3";
      this.metroLabel3.Size = new System.Drawing.Size(43, 19);
      this.metroLabel3.TabIndex = 12;
      this.metroLabel3.Text = "Payee";
      // 
      // metroLabel4
      // 
      this.metroLabel4.AutoSize = true;
      this.metroLabel4.Location = new System.Drawing.Point(42, 169);
      this.metroLabel4.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
      this.metroLabel4.Name = "metroLabel4";
      this.metroLabel4.Size = new System.Drawing.Size(89, 19);
      this.metroLabel4.TabIndex = 12;
      this.metroLabel4.Text = "Category:Sub";
      // 
      // metroLabel5
      // 
      this.metroLabel5.AutoSize = true;
      this.metroLabel5.Location = new System.Drawing.Point(42, 215);
      this.metroLabel5.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
      this.metroLabel5.Name = "metroLabel5";
      this.metroLabel5.Size = new System.Drawing.Size(74, 19);
      this.metroLabel5.TabIndex = 12;
      this.metroLabel5.Text = "Description";
      // 
      // metroLabel6
      // 
      this.metroLabel6.AutoSize = true;
      this.metroLabel6.Location = new System.Drawing.Point(42, 259);
      this.metroLabel6.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
      this.metroLabel6.Name = "metroLabel6";
      this.metroLabel6.Size = new System.Drawing.Size(56, 19);
      this.metroLabel6.TabIndex = 12;
      this.metroLabel6.Text = "Amount";
      // 
      // cmbSubcat
      // 
      this.cmbSubcat.FormattingEnabled = true;
      this.cmbSubcat.ItemHeight = 23;
      this.cmbSubcat.Location = new System.Drawing.Point(377, 159);
      this.cmbSubcat.Margin = new System.Windows.Forms.Padding(2);
      this.cmbSubcat.Name = "cmbSubcat";
      this.cmbSubcat.Size = new System.Drawing.Size(237, 29);
      this.cmbSubcat.TabIndex = 5;
      this.cmbSubcat.UseSelectable = true;
      // 
      // edtDescription
      // 
      // 
      // 
      // 
      this.edtDescription.CustomButton.Image = null;
      this.edtDescription.CustomButton.Location = new System.Drawing.Point(445, 1);
      this.edtDescription.CustomButton.Name = "";
      this.edtDescription.CustomButton.Size = new System.Drawing.Size(27, 27);
      this.edtDescription.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
      this.edtDescription.CustomButton.TabIndex = 1;
      this.edtDescription.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
      this.edtDescription.CustomButton.UseSelectable = true;
      this.edtDescription.CustomButton.Visible = false;
      this.edtDescription.FontSize = MetroFramework.MetroTextBoxSize.Medium;
      this.edtDescription.Lines = new string[0];
      this.edtDescription.Location = new System.Drawing.Point(141, 205);
      this.edtDescription.MaxLength = 32767;
      this.edtDescription.Multiline = true;
      this.edtDescription.Name = "edtDescription";
      this.edtDescription.PasswordChar = '\0';
      this.edtDescription.ScrollBars = System.Windows.Forms.ScrollBars.None;
      this.edtDescription.SelectedText = "";
      this.edtDescription.SelectionLength = 0;
      this.edtDescription.SelectionStart = 0;
      this.edtDescription.ShortcutsEnabled = true;
      this.edtDescription.Size = new System.Drawing.Size(473, 29);
      this.edtDescription.TabIndex = 6;
      this.edtDescription.UseSelectable = true;
      this.edtDescription.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
      this.edtDescription.WaterMarkFont = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      // 
      // edtAmount
      // 
      // 
      // 
      // 
      this.edtAmount.CustomButton.Image = null;
      this.edtAmount.CustomButton.Location = new System.Drawing.Point(67, 1);
      this.edtAmount.CustomButton.Name = "";
      this.edtAmount.CustomButton.Size = new System.Drawing.Size(27, 27);
      this.edtAmount.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
      this.edtAmount.CustomButton.TabIndex = 1;
      this.edtAmount.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
      this.edtAmount.CustomButton.UseSelectable = true;
      this.edtAmount.CustomButton.Visible = false;
      this.edtAmount.FontSize = MetroFramework.MetroTextBoxSize.Medium;
      this.edtAmount.Lines = new string[0];
      this.edtAmount.Location = new System.Drawing.Point(141, 249);
      this.edtAmount.MaxLength = 32767;
      this.edtAmount.Multiline = true;
      this.edtAmount.Name = "edtAmount";
      this.edtAmount.PasswordChar = '\0';
      this.edtAmount.ScrollBars = System.Windows.Forms.ScrollBars.None;
      this.edtAmount.SelectedText = "";
      this.edtAmount.SelectionLength = 0;
      this.edtAmount.SelectionStart = 0;
      this.edtAmount.ShortcutsEnabled = true;
      this.edtAmount.Size = new System.Drawing.Size(95, 29);
      this.edtAmount.TabIndex = 7;
      this.edtAmount.UseSelectable = true;
      this.edtAmount.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
      this.edtAmount.WaterMarkFont = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Pixel);
      // 
      // edtID
      // 
      // 
      // 
      // 
      this.edtID.CustomButton.Image = null;
      this.edtID.CustomButton.Location = new System.Drawing.Point(60, 1);
      this.edtID.CustomButton.Name = "";
      this.edtID.CustomButton.Size = new System.Drawing.Size(21, 21);
      this.edtID.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
      this.edtID.CustomButton.TabIndex = 1;
      this.edtID.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
      this.edtID.CustomButton.UseSelectable = true;
      this.edtID.CustomButton.Visible = false;
      this.edtID.FontSize = MetroFramework.MetroTextBoxSize.Medium;
      this.edtID.ForeColor = System.Drawing.SystemColors.ActiveCaption;
      this.edtID.Lines = new string[0];
      this.edtID.Location = new System.Drawing.Point(532, 25);
      this.edtID.MaxLength = 32767;
      this.edtID.Name = "edtID";
      this.edtID.PasswordChar = '\0';
      this.edtID.ReadOnly = true;
      this.edtID.ScrollBars = System.Windows.Forms.ScrollBars.None;
      this.edtID.SelectedText = "";
      this.edtID.SelectionLength = 0;
      this.edtID.SelectionStart = 0;
      this.edtID.ShortcutsEnabled = true;
      this.edtID.Size = new System.Drawing.Size(82, 23);
      this.edtID.TabIndex = 0;
      this.edtID.TabStop = false;
      this.edtID.UseSelectable = true;
      this.edtID.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
      this.edtID.WaterMarkFont = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Pixel);
      // 
      // btnOK
      // 
      this.btnOK.ActiveControl = null;
      this.btnOK.Location = new System.Drawing.Point(438, 254);
      this.btnOK.Name = "btnOK";
      this.btnOK.Size = new System.Drawing.Size(84, 42);
      this.btnOK.TabIndex = 8;
      this.btnOK.Text = "OK";
      this.btnOK.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
      this.btnOK.UseSelectable = true;
      this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
      // 
      // lbType
      // 
      this.lbType.FormattingEnabled = true;
      this.lbType.ItemHeight = 23;
      this.lbType.Items.AddRange(new object[] {
            "Pay",
            "Deposit",
            "Transfer"});
      this.lbType.Location = new System.Drawing.Point(141, 73);
      this.lbType.Name = "lbType";
      this.lbType.Size = new System.Drawing.Size(121, 29);
      this.lbType.TabIndex = 1;
      this.lbType.UseSelectable = true;
      // 
      // cmbPayee
      // 
      this.cmbPayee.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
      this.cmbPayee.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
      this.cmbPayee.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.cmbPayee.FormattingEnabled = true;
      this.cmbPayee.Location = new System.Drawing.Point(141, 115);
      this.cmbPayee.Name = "cmbPayee";
      this.cmbPayee.Size = new System.Drawing.Size(223, 29);
      this.cmbPayee.TabIndex = 3;
      this.cmbPayee.Validating += new System.ComponentModel.CancelEventHandler(this.cmbPayee_Validating);
      // 
      // frmModalRecord
      // 
      this.AcceptButton = this.btnOK;
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(663, 317);
      this.Controls.Add(this.cmbPayee);
      this.Controls.Add(this.lbType);
      this.Controls.Add(this.btnOK);
      this.Controls.Add(this.edtID);
      this.Controls.Add(this.edtAmount);
      this.Controls.Add(this.edtDescription);
      this.Controls.Add(this.dtData);
      this.Controls.Add(this.cmbSubcat);
      this.Controls.Add(this.cmbCategory);
      this.Controls.Add(this.metroLabel6);
      this.Controls.Add(this.metroLabel5);
      this.Controls.Add(this.metroLabel4);
      this.Controls.Add(this.metroLabel3);
      this.Controls.Add(this.metroLabel2);
      this.Controls.Add(this.metroLabel1);
      this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
      this.KeyPreview = true;
      this.Name = "frmModalRecord";
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
      this.Text = "Insert/Edit Record";
      this.Load += new System.EventHandler(this.frmModalRecord_Load);
      this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.frmModalRecord_KeyPress);
      this.Validating += new System.ComponentModel.CancelEventHandler(this.frmModalRecord_Validating);
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion
        private MetroFramework.Controls.MetroLabel metroLabel1;
        private MetroFramework.Controls.MetroComboBox cmbCategory;
        private MetroFramework.Controls.MetroDateTime dtData;
        private MetroFramework.Controls.MetroLabel metroLabel2;
        private MetroFramework.Controls.MetroLabel metroLabel3;
        private MetroFramework.Controls.MetroLabel metroLabel4;
        private MetroFramework.Controls.MetroLabel metroLabel5;
        private MetroFramework.Controls.MetroLabel metroLabel6;
        private MetroFramework.Controls.MetroComboBox cmbSubcat;
        private MetroFramework.Controls.MetroTextBox edtDescription;
        private MetroFramework.Controls.MetroTextBox edtAmount;
        private MetroFramework.Controls.MetroTextBox edtID;
    private MetroFramework.Controls.MetroTile btnOK;
    private MetroFramework.Controls.MetroComboBox lbType;
    private System.Windows.Forms.ComboBox cmbPayee;
  }
}