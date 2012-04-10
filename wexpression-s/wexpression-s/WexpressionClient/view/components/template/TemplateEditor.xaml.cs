using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Com.Settinghead.Wexpression.Client.Model.Vo.Template;
using System.ComponentModel;


namespace Com.Settinghead.Wexpression.Client.View.Components.Template
{

    public delegate void RenderTuHandler(Object sender);
    public delegate void SaveTemplateHandler(Object sender);
    public delegate void UploadTemplateHandler(Object sender);

    public partial class TemplateEditor : UserControl, INotifyPropertyChanged
    {
        #region Events
        public event PropertyChangedEventHandler PropertyChanged;
        public event RenderTuHandler RenderTu;
        public event SaveTemplateHandler SaveTemplate;
        public event UploadTemplateHandler UploadTemplate;
        #endregion
        private TemplateVO _template;
        private UserControl _imageContainer;
        private UserControl _currentViewContainer;

        public TemplateEditor()
        {
            InitializeComponent();
        }

        public TemplateVO Template
        {
            get
            {
                return _template;
            }
            set
            {
                this._template = value;
            }
        }

        private void TemplateEditor_Loaded(object sender, RoutedEventArgs e)
        {
            populateTemplate();
        }

        private void populateTemplate()
        {
            if (this.Template != null)
            {
            }
        }
        #region Events Handler

        private void btnRender_Click(object sender, RoutedEventArgs e)
        {
            if (RenderTu != null) RenderTu(this);
        }
        private void btmSaveTemplate_Click(object sender, RoutedEventArgs e)
        {
            if (SaveTemplate != null) SaveTemplate(this);
        }

        private void btnUploadTemplate_Click(object sender, RoutedEventArgs e)
        {
            if (UploadTemplate != null) UploadTemplate(this);
        }
        #endregion





    }
}
