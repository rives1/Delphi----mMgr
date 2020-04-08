namespace mmgr
{
    partial class frmMain
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
            System.Windows.Forms.TreeNode treeNode1 = new System.Windows.Forms.TreeNode("mmgr*");
            System.Windows.Forms.DataVisualization.Charting.ChartArea chartArea1 = new System.Windows.Forms.DataVisualization.Charting.ChartArea();
            System.Windows.Forms.DataVisualization.Charting.Series series1 = new System.Windows.Forms.DataVisualization.Charting.Series();
            this.dSet = new System.Data.DataSet();
            this.imgStore = new System.Windows.Forms.ImageList(this.components);
            this.metroPanel1 = new MetroFramework.Controls.MetroPanel();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.treeMenu = new System.Windows.Forms.TreeView();
            this.chTotals = new System.Windows.Forms.DataVisualization.Charting.Chart();
            ((System.ComponentModel.ISupportInitialize)(this.dSet)).BeginInit();
            this.metroPanel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.chTotals)).BeginInit();
            this.SuspendLayout();
            // 
            // dSet
            // 
            this.dSet.DataSetName = "dSetName";
            // 
            // imgStore
            // 
            this.imgStore.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imgStore.ImageStream")));
            this.imgStore.TransparentColor = System.Drawing.Color.Black;
            this.imgStore.Images.SetKeyName(0, "AppLogo.png");
            this.imgStore.Images.SetKeyName(1, "account_bank.png");
            this.imgStore.Images.SetKeyName(2, "account_cash.png");
            this.imgStore.Images.SetKeyName(3, "account_creditcard.png");
            this.imgStore.Images.SetKeyName(4, "chart_bar.png");
            this.imgStore.Images.SetKeyName(5, "chart_pie.png");
            this.imgStore.Images.SetKeyName(6, "chart_report.png");
            this.imgStore.Images.SetKeyName(7, "Chart_Head.png");
            this.imgStore.Images.SetKeyName(8, "config_category.png");
            this.imgStore.Images.SetKeyName(9, "config_account.png");
            this.imgStore.Images.SetKeyName(10, "config_payee.png");
            // 
            // metroPanel1
            // 
            this.metroPanel1.BackColor = System.Drawing.Color.Silver;
            this.metroPanel1.Controls.Add(this.splitContainer1);
            this.metroPanel1.Dock = System.Windows.Forms.DockStyle.Left;
            this.metroPanel1.HorizontalScrollbarBarColor = true;
            this.metroPanel1.HorizontalScrollbarHighlightOnWheel = false;
            this.metroPanel1.HorizontalScrollbarSize = 6;
            this.metroPanel1.Location = new System.Drawing.Point(20, 60);
            this.metroPanel1.Margin = new System.Windows.Forms.Padding(2);
            this.metroPanel1.Name = "metroPanel1";
            this.metroPanel1.Padding = new System.Windows.Forms.Padding(5);
            this.metroPanel1.Size = new System.Drawing.Size(250, 584);
            this.metroPanel1.TabIndex = 6;
            this.metroPanel1.VerticalScrollbarBarColor = true;
            this.metroPanel1.VerticalScrollbarHighlightOnWheel = false;
            this.metroPanel1.VerticalScrollbarSize = 7;
            // 
            // splitContainer1
            // 
            this.splitContainer1.BackColor = System.Drawing.Color.Silver;
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(5, 5);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.treeMenu);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.chTotals);
            this.splitContainer1.Size = new System.Drawing.Size(240, 574);
            this.splitContainer1.SplitterDistance = 368;
            this.splitContainer1.SplitterWidth = 10;
            this.splitContainer1.TabIndex = 3;
            // 
            // treeMenu
            // 
            this.treeMenu.BackColor = System.Drawing.Color.Silver;
            this.treeMenu.Dock = System.Windows.Forms.DockStyle.Fill;
            this.treeMenu.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.treeMenu.ForeColor = System.Drawing.Color.Black;
            this.treeMenu.FullRowSelect = true;
            this.treeMenu.HotTracking = true;
            this.treeMenu.ItemHeight = 20;
            this.treeMenu.LineColor = System.Drawing.Color.White;
            this.treeMenu.Location = new System.Drawing.Point(0, 0);
            this.treeMenu.Name = "treeMenu";
            treeNode1.ImageKey = "(default)";
            treeNode1.Name = "Node0";
            treeNode1.SelectedImageKey = "(default)";
            treeNode1.StateImageKey = "AppHead.png";
            treeNode1.Tag = " ";
            treeNode1.Text = "mmgr*";
            this.treeMenu.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode1});
            this.treeMenu.ShowRootLines = false;
            this.treeMenu.Size = new System.Drawing.Size(240, 368);
            this.treeMenu.StateImageList = this.imgStore;
            this.treeMenu.TabIndex = 3;
            this.treeMenu.DoubleClick += new System.EventHandler(this.treeMenu_DoubleClick);
            this.treeMenu.KeyDown += new System.Windows.Forms.KeyEventHandler(this.treeMenu_KeyDown);
            // 
            // chTotals
            // 
            this.chTotals.BackColor = System.Drawing.Color.Transparent;
            this.chTotals.BorderlineColor = System.Drawing.Color.Transparent;
            chartArea1.Area3DStyle.Inclination = 25;
            chartArea1.Area3DStyle.LightStyle = System.Windows.Forms.DataVisualization.Charting.LightStyle.Realistic;
            chartArea1.Area3DStyle.Rotation = 15;
            chartArea1.Area3DStyle.WallWidth = 6;
            chartArea1.AxisX.IsLabelAutoFit = false;
            chartArea1.AxisX.LabelStyle.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            chartArea1.AxisX.MajorGrid.Enabled = false;
            chartArea1.AxisY.IsLabelAutoFit = false;
            chartArea1.AxisY.LabelStyle.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            chartArea1.AxisY.LabelStyle.Format = "{0:0,}K";
            chartArea1.AxisY.MajorGrid.Enabled = false;
            chartArea1.BackColor = System.Drawing.Color.Transparent;
            chartArea1.Name = "ChartArea1";
            this.chTotals.ChartAreas.Add(chartArea1);
            this.chTotals.Dock = System.Windows.Forms.DockStyle.Fill;
            this.chTotals.Location = new System.Drawing.Point(0, 0);
            this.chTotals.Name = "chTotals";
            this.chTotals.Palette = System.Windows.Forms.DataVisualization.Charting.ChartColorPalette.Pastel;
            series1.ChartArea = "ChartArea1";
            series1.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            series1.IsValueShownAsLabel = true;
            series1.IsVisibleInLegend = false;
            series1.LabelFormat = "{0:0,}K";
            series1.Name = "Totals";
            this.chTotals.Series.Add(series1);
            this.chTotals.Size = new System.Drawing.Size(240, 196);
            this.chTotals.TabIndex = 1;
            this.chTotals.TabStop = false;
            this.chTotals.Text = "-";
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1268, 664);
            this.Controls.Add(this.metroPanel1);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.IsMdiContainer = true;
            this.Name = "frmMain";
            this.ShadowType = MetroFramework.Forms.MetroFormShadowType.AeroShadow;
            this.Style = MetroFramework.MetroColorStyle.Lime;
            this.Text = "m.mgr*";
            this.Theme = MetroFramework.MetroThemeStyle.Default;
            this.TransparencyKey = System.Drawing.Color.Empty;
            this.Load += new System.EventHandler(this.FrmLedger_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dSet)).EndInit();
            this.metroPanel1.ResumeLayout(false);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.chTotals)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Data.DataSet dSet;
    private System.Windows.Forms.ImageList imgStore;
        private MetroFramework.Controls.MetroPanel metroPanel1;
    private System.Windows.Forms.SplitContainer splitContainer1;
    private System.Windows.Forms.TreeView treeMenu;
    private System.Windows.Forms.DataVisualization.Charting.Chart chTotals;
  }
}

