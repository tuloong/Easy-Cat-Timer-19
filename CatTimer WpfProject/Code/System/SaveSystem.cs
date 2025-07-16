﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CatTimer_WpfProject
{
    /// <summary>
    /// 保存&读取 系统
    /// </summary>
    public class SaveSystem
    {
        /// <summary>
        /// 保存
        /// </summary>
        public void Save()
        {
            Properties.Settings.Default.Volume = AppManager.AppDatas.SettingData.Volume;//是否有声音？
            Properties.Settings.Default.Language = (int)AppManager.AppDatas.SettingData.Language;//语言
            Properties.Settings.Default.StartupOnBoot = AppManager.AppDatas.SettingData.StartupOnBoot;//开机自启动

            Properties.Settings.Default.Save();
        }

        
        /// <summary>
        /// 读取
        /// </summary>
        public void Load()
        {
            AppManager.AppDatas.SettingData.Volume = Properties.Settings.Default.Volume;
            AppManager.AppDatas.SettingData.Language = (LanguageType) Properties.Settings.Default.Language;
            AppManager.AppDatas.SettingData.StartupOnBoot = Properties.Settings.Default.StartupOnBoot;

            //同步开机自启动状态
            bool actualStartupStatus = AppManager.AppSystems.SystemStartupSystem.IsStartupOnBootEnabled();
            if (actualStartupStatus != AppManager.AppDatas.SettingData.StartupOnBoot)
            {
                AppManager.AppDatas.SettingData.StartupOnBoot = actualStartupStatus;
                Properties.Settings.Default.StartupOnBoot = actualStartupStatus;
            }

            //更改UI
            AppManager.AppSystems.LanguageSystem.SetLanguage(AppManager.AppDatas.SettingData.Language);

        }
    }
}
