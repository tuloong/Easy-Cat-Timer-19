using System;
using Microsoft.Win32;
using System.Windows;
using System.IO;

namespace CatTimer_WpfProject
{
    /// <summary>
    /// 系统启动管理系统
    /// </summary>
    public class SystemStartupSystem
    {
        private const string RegistryKeyPath = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run";
        private const string AppName = "EasyCatTimer";

        /// <summary>
        /// 设置开机自启动
        /// </summary>
        /// <param name="enable">是否启用开机自启动</param>
        public void SetStartupOnBoot(bool enable)
        {
            try
            {
                using (RegistryKey registryKey = Registry.CurrentUser.OpenSubKey(RegistryKeyPath, true))
                {
                    if (registryKey != null)
                    {
                        if (enable)
                        {
                            string executablePath = GetExecutablePath();
                            if (!string.IsNullOrEmpty(executablePath))
                            {
                                registryKey.SetValue(AppName, executablePath);
                            }
                        }
                        else
                        {
                            if (registryKey.GetValue(AppName) != null)
                            {
                                registryKey.DeleteValue(AppName);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // 记录错误但不影响主程序运行
                Console.WriteLine($"设置开机自启动失败: {ex.Message}");
            }
        }

        /// <summary>
        /// 检查是否已设置开机自启动
        /// </summary>
        /// <returns>是否已设置开机自启动</returns>
        public bool IsStartupOnBootEnabled()
        {
            try
            {
                using (RegistryKey registryKey = Registry.CurrentUser.OpenSubKey(RegistryKeyPath, false))
                {
                    if (registryKey != null)
                    {
                        object value = registryKey.GetValue(AppName);
                        return value != null;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"检查开机自启动状态失败: {ex.Message}");
            }
            return false;
        }

        /// <summary>
        /// 获取可执行文件路径
        /// </summary>
        /// <returns>可执行文件完整路径</returns>
        private string GetExecutablePath()
        {
            try
            {
                string path = System.Reflection.Assembly.GetEntryAssembly()?.Location;
                if (!string.IsNullOrEmpty(path) && File.Exists(path))
                {
                    return path;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"获取可执行文件路径失败: {ex.Message}");
            }
            return string.Empty;
        }
    }
}