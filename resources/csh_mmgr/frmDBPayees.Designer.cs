namespace mmgr
{
  partial class frmDBPayees
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
            System.Windows.Forms.DataVisualization.Charting.ChartArea chartArea1 = new System.Windows.Forms.DataVisualization.Charting.ChartArea();
            System.Windows.Forms.DataVisualization.Charting.StripLine stripLine1 = new System.Windows.Forms.DataVisualization.Charting.StripLine();
            System.Windows.Forms.DataVisualization.Charting.Series series1 = new System.Windows.Forms.DataVisualization.Charting.Series();
            System.Windows.Forms.DataVisualization.Charting.Title title1 = new System.Windows.Forms.DataVisualization.Charting.Title();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.treePayees = new System.Windows.Forms.TreeView();
            this.metroPanel1 = new MetroFramework.Controls.MetroPanel();
            this.chHistory = new System.Windows.Forms.DataVisualization.Charting.Chart();
            this.edtID = new MetroFramework.Controls.MetroTextBox();
            this.edtType = new MetroFramework.Controls.MetroTextBox();
            this.btnOK = new MetroFramework.Controls.MetroTile();
            this.metroLabel1 = new MetroFramework.Controls.MetroLabel();
            this.edtName = new MetroFramework.Controls.MetroTextBox();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.metroPanel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.chHistory)).BeginInit();
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
            this.splitContainer1.Panel1.Controls.Add(this.treePayees);
            this.splitContainer1.Panel1.Padding = new System.Windows.Forms.Padding(5);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.splitContainer1.Panel2.Controls.Add(this.metroPanel1);
            this.splitContainer1.Panel2.Controls.Add(this.edtID);
            this.splitContainer1.Panel2.Controls.Add(this.edtType);
            this.splitContainer1.Panel2.Controls.Add(this.btnOK);
            this.splitContainer1.Panel2.Controls.Add(this.metroLabel1);
            this.splitContainer1.Panel2.Controls.Add(this.edtName);
            this.splitContainer1.Size = new System.Drawing.Size(713, 484);
            this.splitContainer1.SplitterDistance = 250;
            this.splitContainer1.TabIndex = 1;
            // 
            // treePayees
            // 
            this.treePayees.BackColor = System.Drawing.Color.Gray;
            this.treePayees.Dock = System.Windows.Forms.DockStyle.Fill;
            this.treePayees.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.treePayees.Location = new System.Drawing.Point(5, 5);
            this.treePayees.Margin = new System.Windows.Forms.Padding(5);
            this.treePayees.Name = "treePayees";
            this.treePayees.Size = new System.Drawing.Size(240, 474);
            this.treePayees.TabIndex = 0;
            this.treePayees.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.treePayees_MouseDoubleClick);
            // 
            // metroPanel1
            // 
            this.metroPanel1.Controls.Add(this.chHistory);
            this.metroPanel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.metroPanel1.HorizontalScrollbarBarColor = true;
            this.metroPanel1.HorizontalScrollbarHighlightOnWheel = false;
            this.metroPanel1.HorizontalScrollbarSize = 10;
            this.metroPanel1.Location = new System.Drawing.Point(0, 297);
            this.metroPanel1.Name = "metroPanel1";
            this.metroPanel1.Size = new System.Drawing.Size(459, 187);
            this.metroPanel1.TabIndex = 13;
            this.metroPanel1.VerticalScrollbarBarColor = true;
            this.metroPanel1.VerticalScrollbarHighlightOnWheel = false;
            this.metroPanel1.VerticalScrollbarSize = 10;
            // 
            // chHistory
            // 
            this.chHistory.BackColor = System.Drawing.Color.Transparent;
            this.chHistory.BorderlineColor = System.Drawing.Color.Transparent;
            chartArea1.AxisX.ArrowStyle = System.Windows.Forms.DataVisualization.Charting.AxisArrowStyle.Triangle;
            chartArea1.AxisX.IsLabelAutoFit = false;
            chartArea1.AxisX.LabelStyle.Angle = 50;
            chartArea1.AxisX.LabelStyle.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            chartArea1.AxisX.MajorGrid.LineColor = System.Drawing.Color.LightGray;
            chartArea1.AxisX.ScaleBreakStyle.Enabled = true;
            stripLine1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(192)))), ((int)(((byte)(128)))));
            chartArea1.AxisX.StripLines.Add(stripLine1);
            chartArea1.AxisX.TitleFont = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            chartArea1.AxisY.IsLabelAutoFit = false;
            chartArea1.AxisY.LabelAutoFitMaxFontSize = 8;
            chartArea1.AxisY.LabelStyle.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            chartArea1.AxisY.LabelStyle.Format = "{0:0,}K";
            chartArea1.AxisY.LabelStyle.Interval = 0D;
            chartArea1.AxisY.LabelStyle.IntervalType = System.Windows.Forms.DataVisualization.Charting.DateTimeIntervalType.Auto;
            chartArea1.AxisY.MajorGrid.Enabled = false;
            chartArea1.BackColor = System.Drawing.Color.Transparent;
            chartArea1.Name = "ChartArea1";
            this.chHistory.ChartAreas.Add(chartArea1);
            this.chHistory.Dock = System.Windows.Forms.DockStyle.Fill;
            this.chHistory.Location = new System.Drawing.Point(0, 0);
            this.chHistory.Name = "chHistory";
            series1.ChartArea = "ChartArea1";
            series1.IsValueShownAsLabel = true;
            series1.LabelFormat = "{0:0,}K";
            series1.Name = "History";
            series1.YValueType = System.Windows.Forms.DataVisualization.Charting.ChartValueType.Double;
            this.chHistory.Series.Add(series1);
            this.chHistory.Size = new System.Drawing.Size(459, 187);
            this.chHistory.TabIndex = 13;
            this.chHistory.Text = "-";
            title1.Alignment = System.Drawing.ContentAlignment.BottomRight;
            title1.DockedToChartArea = "ChartArea1";
            title1.Docking = System.Windows.Forms.DataVisualization.Charting.Docking.Bottom;
            title1.IsDockedInsideChartArea = false;
            title1.Name = "chTitle";
            title1.Text = "-";
            this.chHistory.Titles.Add(title1);
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
            this.btnOK.Location = new System.Drawing.Point(320, 204);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(107, 42);
            this.btnOK.TabIndex = 10;
            this.btnOK.Text = "Update";
            this.btnOK.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.btnOK.UseSelectable = true;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // metroLabel1
            // 
            this.metroLabel1.AutoSize = true;
            this.metroLabel1.Location = new System.Drawing.Point(39, 84);
            this.metroLabel1.Name = "metroLabel1";
            this.metroLabel1.Size = new System.Drawing.Size(45, 19);
            this.metroLabel1.TabIndex = 8;
            this.metroLabel1.Text = "Name";
            // 
            // edtName
            // 
            // 
            // 
            // 
            this.edtName.CustomButton.Image = null;
            this.edtName.CustomButton.Location = new System.Drawing.Point(360, 1);
            this.edtName.CustomButton.Name = "";
            this.edtName.CustomButton.Size = new System.Drawing.Size(27, 27);
            this.edtName.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
            this.edtName.CustomButton.TabIndex = 1;
            this.edtName.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
            this.edtName.CustomButton.UseSelectable = true;
            this.edtName.CustomButton.Visible = false;
            this.edtName.FontSize = MetroFramework.MetroTextBoxSize.Medium;
            this.edtName.Lines = new string[0];
            this.edtName.Location = new System.Drawing.Point(39, 115);
            this.edtName.MaxLength = 32767;
            this.edtName.Multiline = true;
            this.edtName.Name = "edtName";
            this.edtName.PasswordChar = '\0';
            this.edtName.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.edtName.SelectedText = "";
            this.edtName.SelectionLength = 0;
            this.edtName.SelectionStart = 0;
            this.edtName.ShortcutsEnabled = true;
            this.edtName.Size = new System.Drawing.Size(388, 29);
            this.edtName.TabIndex = 7;
            this.edtName.UseSelectable = true;
            this.edtName.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.edtName.WaterMarkFont = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            // 
            // frmDBPayees
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(753, 564);
            this.Controls.Add(this.splitContainer1);
            this.MaximizeBox = false;
            this.Name = "frmDBPayees";
            this.Text = "Payees";
            this.Load += new System.EventHandler(this.frmDBPayees_Load);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.metroPanel1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.chHistory)).EndInit();
            this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.SplitContainer splitContainer1;
    private System.Windows.Forms.TreeView treePayees;
    private MetroFramework.Controls.MetroTextBox edtID;
    private MetroFramework.Controls.MetroTextBox edtType;
    private MetroFramework.Controls.MetroTile btnOK;
    private MetroFramework.Controls.MetroLabel metroLabel1;
    private MetroFramework.Controls.MetroTextBox edtName;
    private MetroFramework.Controls.MetroPanel metroPanel1;
    private System.Windows.Forms.DataVisualization.Charting.Chart chHistory;
  }
}