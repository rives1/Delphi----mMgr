namespace mmgr
{
    partial class FrmChildLedger
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataVisualization.Charting.ChartArea chartArea1 = new System.Windows.Forms.DataVisualization.Charting.ChartArea();
            System.Windows.Forms.DataVisualization.Charting.StripLine stripLine1 = new System.Windows.Forms.DataVisualization.Charting.StripLine();
            System.Windows.Forms.DataVisualization.Charting.Series series1 = new System.Windows.Forms.DataVisualization.Charting.Series();
            System.Windows.Forms.DataVisualization.Charting.Title title1 = new System.Windows.Forms.DataVisualization.Charting.Title();
            System.Windows.Forms.DataVisualization.Charting.ChartArea chartArea2 = new System.Windows.Forms.DataVisualization.Charting.ChartArea();
            System.Windows.Forms.DataVisualization.Charting.Legend legend1 = new System.Windows.Forms.DataVisualization.Charting.Legend();
            System.Windows.Forms.DataVisualization.Charting.Series series2 = new System.Windows.Forms.DataVisualization.Charting.Series();
            System.Windows.Forms.DataVisualization.Charting.Title title2 = new System.Windows.Forms.DataVisualization.Charting.Title();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FrmChildLedger));
            this.dSet = new System.Data.DataSet();
            this.tblTransaction = new System.Data.DataTable();
            this.dataColumn1 = new System.Data.DataColumn();
            this.dataColumn2 = new System.Data.DataColumn();
            this.dataColumn3 = new System.Data.DataColumn();
            this.dataColumn4 = new System.Data.DataColumn();
            this.dataColumn5 = new System.Data.DataColumn();
            this.dataColumn6 = new System.Data.DataColumn();
            this.dataColumn7 = new System.Data.DataColumn();
            this.dataColumn8 = new System.Data.DataColumn();
            this.dataColumn9 = new System.Data.DataColumn();
            this.panel1 = new System.Windows.Forms.Panel();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.dtGrd = new MetroFramework.Controls.MetroGrid();
            this.trnIDDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnTypeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnDateDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnPayeeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnCategoryDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnDesDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnAmountOUT = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnAmountIN = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.trnRunningSum = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.chHistory = new System.Windows.Forms.DataVisualization.Charting.Chart();
            this.chTotals = new System.Windows.Forms.DataVisualization.Charting.Chart();
            ((System.ComponentModel.ISupportInitialize)(this.dSet)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tblTransaction)).BeginInit();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dtGrd)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.chHistory)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.chTotals)).BeginInit();
            this.SuspendLayout();
            // 
            // dSet
            // 
            this.dSet.DataSetName = "dsetTransaction";
            this.dSet.Tables.AddRange(new System.Data.DataTable[] {
            this.tblTransaction});
            // 
            // tblTransaction
            // 
            this.tblTransaction.Columns.AddRange(new System.Data.DataColumn[] {
            this.dataColumn1,
            this.dataColumn2,
            this.dataColumn3,
            this.dataColumn4,
            this.dataColumn5,
            this.dataColumn6,
            this.dataColumn7,
            this.dataColumn8,
            this.dataColumn9});
            this.tblTransaction.Constraints.AddRange(new System.Data.Constraint[] {
            new System.Data.UniqueConstraint("Constraint1", new string[] {
                        "trnID"}, true)});
            this.tblTransaction.PrimaryKey = new System.Data.DataColumn[] {
        this.dataColumn1};
            this.tblTransaction.TableName = "tblTransaction";
            // 
            // dataColumn1
            // 
            this.dataColumn1.AllowDBNull = false;
            this.dataColumn1.ColumnName = "trnID";
            this.dataColumn1.DataType = typeof(long);
            // 
            // dataColumn2
            // 
            this.dataColumn2.ColumnName = "trnType";
            // 
            // dataColumn3
            // 
            this.dataColumn3.ColumnName = "trnDate";
            this.dataColumn3.DataType = typeof(System.DateTime);
            // 
            // dataColumn4
            // 
            this.dataColumn4.ColumnName = "trnPayee";
            // 
            // dataColumn5
            // 
            this.dataColumn5.ColumnName = "trnCategory";
            // 
            // dataColumn6
            // 
            this.dataColumn6.ColumnName = "trnDes";
            // 
            // dataColumn7
            // 
            this.dataColumn7.ColumnName = "trnAmountOUT";
            this.dataColumn7.DataType = typeof(double);
            // 
            // dataColumn8
            // 
            this.dataColumn8.ColumnName = "trnAmountIN";
            this.dataColumn8.DataType = typeof(double);
            // 
            // dataColumn9
            // 
            this.dataColumn9.ColumnName = "trnRunningSum";
            this.dataColumn9.DataType = typeof(double);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.splitContainer1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(20, 60);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(820, 482);
            this.panel1.TabIndex = 6;
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.dtGrd);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.chHistory);
            this.splitContainer1.Panel2.Controls.Add(this.chTotals);
            this.splitContainer1.Size = new System.Drawing.Size(820, 482);
            this.splitContainer1.SplitterDistance = 271;
            this.splitContainer1.TabIndex = 6;
            // 
            // dtGrd
            // 
            this.dtGrd.AllowUserToAddRows = false;
            this.dtGrd.AllowUserToDeleteRows = false;
            this.dtGrd.AllowUserToResizeRows = false;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            dataGridViewCellStyle1.Padding = new System.Windows.Forms.Padding(2);
            this.dtGrd.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle1;
            this.dtGrd.AutoGenerateColumns = false;
            this.dtGrd.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.dtGrd.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.dtGrd.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.None;
            this.dtGrd.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.None;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(174)))), ((int)(((byte)(219)))));
            dataGridViewCellStyle2.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(198)))), ((int)(((byte)(247)))));
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(17)))), ((int)(((byte)(17)))), ((int)(((byte)(17)))));
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dtGrd.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dtGrd.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dtGrd.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.trnIDDataGridViewTextBoxColumn,
            this.trnTypeDataGridViewTextBoxColumn,
            this.trnDateDataGridViewTextBoxColumn,
            this.trnPayeeDataGridViewTextBoxColumn,
            this.trnCategoryDataGridViewTextBoxColumn,
            this.trnDesDataGridViewTextBoxColumn,
            this.trnAmountOUT,
            this.trnAmountIN,
            this.trnRunningSum});
            this.dtGrd.DataMember = "tblTransaction";
            this.dtGrd.DataSource = this.dSet;
            dataGridViewCellStyle7.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle7.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle7.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(136)))), ((int)(((byte)(136)))), ((int)(((byte)(136)))));
            dataGridViewCellStyle7.SelectionBackColor = System.Drawing.Color.PaleGreen;
            dataGridViewCellStyle7.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(17)))), ((int)(((byte)(17)))), ((int)(((byte)(17)))));
            dataGridViewCellStyle7.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dtGrd.DefaultCellStyle = dataGridViewCellStyle7;
            this.dtGrd.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dtGrd.EnableHeadersVisualStyles = false;
            this.dtGrd.Font = new System.Drawing.Font("Segoe UI", 11F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Pixel);
            this.dtGrd.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.dtGrd.Location = new System.Drawing.Point(0, 0);
            this.dtGrd.MultiSelect = false;
            this.dtGrd.Name = "dtGrd";
            this.dtGrd.ReadOnly = true;
            this.dtGrd.RowHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.Single;
            dataGridViewCellStyle8.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(174)))), ((int)(((byte)(219)))));
            dataGridViewCellStyle8.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle8.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle8.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(198)))), ((int)(((byte)(247)))));
            dataGridViewCellStyle8.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(17)))), ((int)(((byte)(17)))), ((int)(((byte)(17)))));
            dataGridViewCellStyle8.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dtGrd.RowHeadersDefaultCellStyle = dataGridViewCellStyle8;
            this.dtGrd.RowHeadersWidth = 20;
            this.dtGrd.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dtGrd.RowTemplate.DefaultCellStyle.BackColor = System.Drawing.Color.White;
            this.dtGrd.RowTemplate.Height = 20;
            this.dtGrd.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dtGrd.Size = new System.Drawing.Size(820, 271);
            this.dtGrd.TabIndex = 6;
            this.dtGrd.DoubleClick += new System.EventHandler(this.dtGrd_DoubleClick);
            // 
            // trnIDDataGridViewTextBoxColumn
            // 
            this.trnIDDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnIDDataGridViewTextBoxColumn.DataPropertyName = "trnID";
            this.trnIDDataGridViewTextBoxColumn.HeaderText = "ID";
            this.trnIDDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.trnIDDataGridViewTextBoxColumn.Name = "trnIDDataGridViewTextBoxColumn";
            this.trnIDDataGridViewTextBoxColumn.ReadOnly = true;
            this.trnIDDataGridViewTextBoxColumn.Visible = false;
            // 
            // trnTypeDataGridViewTextBoxColumn
            // 
            this.trnTypeDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnTypeDataGridViewTextBoxColumn.DataPropertyName = "trnType";
            this.trnTypeDataGridViewTextBoxColumn.HeaderText = "Type";
            this.trnTypeDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.trnTypeDataGridViewTextBoxColumn.Name = "trnTypeDataGridViewTextBoxColumn";
            this.trnTypeDataGridViewTextBoxColumn.ReadOnly = true;
            this.trnTypeDataGridViewTextBoxColumn.Width = 60;
            // 
            // trnDateDataGridViewTextBoxColumn
            // 
            this.trnDateDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnDateDataGridViewTextBoxColumn.DataPropertyName = "trnDate";
            dataGridViewCellStyle3.Format = "d";
            dataGridViewCellStyle3.NullValue = null;
            this.trnDateDataGridViewTextBoxColumn.DefaultCellStyle = dataGridViewCellStyle3;
            this.trnDateDataGridViewTextBoxColumn.HeaderText = "Date";
            this.trnDateDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.trnDateDataGridViewTextBoxColumn.Name = "trnDateDataGridViewTextBoxColumn";
            this.trnDateDataGridViewTextBoxColumn.ReadOnly = true;
            this.trnDateDataGridViewTextBoxColumn.Width = 61;
            // 
            // trnPayeeDataGridViewTextBoxColumn
            // 
            this.trnPayeeDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnPayeeDataGridViewTextBoxColumn.DataPropertyName = "trnPayee";
            this.trnPayeeDataGridViewTextBoxColumn.HeaderText = "Payee";
            this.trnPayeeDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.trnPayeeDataGridViewTextBoxColumn.Name = "trnPayeeDataGridViewTextBoxColumn";
            this.trnPayeeDataGridViewTextBoxColumn.ReadOnly = true;
            this.trnPayeeDataGridViewTextBoxColumn.Width = 68;
            // 
            // trnCategoryDataGridViewTextBoxColumn
            // 
            this.trnCategoryDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnCategoryDataGridViewTextBoxColumn.DataPropertyName = "trnCategory";
            this.trnCategoryDataGridViewTextBoxColumn.HeaderText = "Category";
            this.trnCategoryDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.trnCategoryDataGridViewTextBoxColumn.Name = "trnCategoryDataGridViewTextBoxColumn";
            this.trnCategoryDataGridViewTextBoxColumn.ReadOnly = true;
            this.trnCategoryDataGridViewTextBoxColumn.Width = 88;
            // 
            // trnDesDataGridViewTextBoxColumn
            // 
            this.trnDesDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.trnDesDataGridViewTextBoxColumn.DataPropertyName = "trnDes";
            this.trnDesDataGridViewTextBoxColumn.HeaderText = "Description";
            this.trnDesDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.trnDesDataGridViewTextBoxColumn.Name = "trnDesDataGridViewTextBoxColumn";
            this.trnDesDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // trnAmountOUT
            // 
            this.trnAmountOUT.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnAmountOUT.DataPropertyName = "trnAmountOUT";
            dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            dataGridViewCellStyle4.Format = "N2";
            dataGridViewCellStyle4.NullValue = null;
            this.trnAmountOUT.DefaultCellStyle = dataGridViewCellStyle4;
            this.trnAmountOUT.HeaderText = "Expenses";
            this.trnAmountOUT.MinimumWidth = 6;
            this.trnAmountOUT.Name = "trnAmountOUT";
            this.trnAmountOUT.ReadOnly = true;
            this.trnAmountOUT.Width = 87;
            // 
            // trnAmountIN
            // 
            this.trnAmountIN.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnAmountIN.DataPropertyName = "trnAmountIN";
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            dataGridViewCellStyle5.Format = "N2";
            dataGridViewCellStyle5.NullValue = null;
            this.trnAmountIN.DefaultCellStyle = dataGridViewCellStyle5;
            this.trnAmountIN.HeaderText = "Incoming";
            this.trnAmountIN.MinimumWidth = 6;
            this.trnAmountIN.Name = "trnAmountIN";
            this.trnAmountIN.ReadOnly = true;
            this.trnAmountIN.Width = 89;
            // 
            // trnRunningSum
            // 
            this.trnRunningSum.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
            this.trnRunningSum.DataPropertyName = "trnRunningSum";
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            dataGridViewCellStyle6.Format = "N2";
            this.trnRunningSum.DefaultCellStyle = dataGridViewCellStyle6;
            this.trnRunningSum.HeaderText = "Balance";
            this.trnRunningSum.MinimumWidth = 6;
            this.trnRunningSum.Name = "trnRunningSum";
            this.trnRunningSum.ReadOnly = true;
            this.trnRunningSum.Width = 78;
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
            this.chHistory.Location = new System.Drawing.Point(343, 0);
            this.chHistory.Name = "chHistory";
            series1.ChartArea = "ChartArea1";
            series1.ChartType = System.Windows.Forms.DataVisualization.Charting.SeriesChartType.Spline;
            series1.IsValueShownAsLabel = true;
            series1.LabelFormat = "{0:0,}K";
            series1.Name = "History";
            series1.YValueType = System.Windows.Forms.DataVisualization.Charting.ChartValueType.Double;
            this.chHistory.Series.Add(series1);
            this.chHistory.Size = new System.Drawing.Size(477, 207);
            this.chHistory.TabIndex = 1;
            this.chHistory.Text = "-";
            title1.Alignment = System.Drawing.ContentAlignment.BottomRight;
            title1.DockedToChartArea = "ChartArea1";
            title1.Docking = System.Windows.Forms.DataVisualization.Charting.Docking.Bottom;
            title1.IsDockedInsideChartArea = false;
            title1.Name = "chTitle";
            title1.Text = "-";
            this.chHistory.Titles.Add(title1);
            // 
            // chTotals
            // 
            this.chTotals.BackColor = System.Drawing.Color.Transparent;
            this.chTotals.BorderlineColor = System.Drawing.Color.Transparent;
            chartArea2.AxisX.LabelAutoFitMaxFontSize = 9;
            chartArea2.AxisX.LabelStyle.Format = "{0:0,}K";
            chartArea2.AxisY.LabelAutoFitMaxFontSize = 9;
            chartArea2.AxisY.LabelStyle.Format = "{0:0,}K";
            chartArea2.BackColor = System.Drawing.Color.Transparent;
            chartArea2.Name = "ChartArea1";
            this.chTotals.ChartAreas.Add(chartArea2);
            this.chTotals.Dock = System.Windows.Forms.DockStyle.Left;
            legend1.BackColor = System.Drawing.Color.Transparent;
            legend1.LegendStyle = System.Windows.Forms.DataVisualization.Charting.LegendStyle.Column;
            legend1.Name = "Legend1";
            this.chTotals.Legends.Add(legend1);
            this.chTotals.Location = new System.Drawing.Point(0, 0);
            this.chTotals.Name = "chTotals";
            series2.ChartArea = "ChartArea1";
            series2.ChartType = System.Windows.Forms.DataVisualization.Charting.SeriesChartType.Doughnut;
            series2.IsValueShownAsLabel = true;
            series2.LabelFormat = "{0:0,}K";
            series2.Legend = "Legend1";
            series2.Name = "Totals";
            series2.SmartLabelStyle.Enabled = false;
            series2.YValueType = System.Windows.Forms.DataVisualization.Charting.ChartValueType.Double;
            this.chTotals.Series.Add(series2);
            this.chTotals.Size = new System.Drawing.Size(343, 207);
            this.chTotals.TabIndex = 0;
            this.chTotals.Text = "-";
            title2.Alignment = System.Drawing.ContentAlignment.TopLeft;
            title2.DockedToChartArea = "ChartArea1";
            title2.IsDockedInsideChartArea = false;
            title2.Name = "chTitle";
            title2.Text = "-";
            this.chTotals.Titles.Add(title2);
            // 
            // FrmChildLedger
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.ClientSize = new System.Drawing.Size(860, 562);
            this.Controls.Add(this.panel1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FrmChildLedger";
            this.Text = "Ledger - ";
            this.Theme = MetroFramework.MetroThemeStyle.Default;
            this.Load += new System.EventHandler(this.FrmChildLedger_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.FrmChildLedger_KeyDown);
            ((System.ComponentModel.ISupportInitialize)(this.dSet)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tblTransaction)).EndInit();
            this.panel1.ResumeLayout(false);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dtGrd)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.chHistory)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.chTotals)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion
    private System.Data.DataSet dSet;
    private System.Data.DataTable tblTransaction;
    private System.Data.DataColumn dataColumn1;
    private System.Data.DataColumn dataColumn2;
    private System.Data.DataColumn dataColumn3;
    private System.Data.DataColumn dataColumn4;
    private System.Data.DataColumn dataColumn5;
    private System.Data.DataColumn dataColumn6;
    private System.Data.DataColumn dataColumn7;
    private System.Windows.Forms.Panel panel1;
    private System.Data.DataColumn dataColumn8;
    private System.Windows.Forms.SplitContainer splitContainer1;
    private MetroFramework.Controls.MetroGrid dtGrd;
    private System.Windows.Forms.DataVisualization.Charting.Chart chTotals;
    private System.Windows.Forms.DataVisualization.Charting.Chart chHistory;
    private System.Data.DataColumn dataColumn9;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnIDDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnTypeDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnDateDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnPayeeDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnCategoryDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnDesDataGridViewTextBoxColumn;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnAmountOUT;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnAmountIN;
    private System.Windows.Forms.DataGridViewTextBoxColumn trnRunningSum;
  }
}