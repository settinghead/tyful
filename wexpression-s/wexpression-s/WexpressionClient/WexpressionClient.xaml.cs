using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using PureMVC.Interfaces;
using PureMVC.Patterns;
namespace Com.Settinghead.Wexpression.Client
{
    public partial class WexpressionClient : UserControl
    {
        private ApplicationFacade Facade;

        public WexpressionClient(ResourceDictionary dict)
        {
            InitializeComponent();
            foreach (var k in dict.Keys)
                this.Resources.Add(k, dict[k]);

            Facade = ApplicationFacade.getInstance() as ApplicationFacade;
            Facade.Startup(this);
        }
    }
}
