'use strict'; /* 厳格にエラーをチェック */

{ /* ローカルスコープ */
  // DOM取得
  const tabMenus = document.querySelectorAll('.tab_menu-item');
  tabMenus.forEach((tabMenu) => {
    tabMenu.addEventListener('click', tabSwitch);
  })

  function tabSwitch(e) {
    // クリックされた要素のデータ属性を取得
    const tabTargetData = e.currentTarget.dataset.tab;
    const tabList = e.currentTarget.closest('.tab_menu');
    const tabItems = tabList.querySelectorAll('.tab_menu-item');

    // クリックされた要素の親要素の兄弟要素の子要素を取得
    const tabPanelItems = tabList.nextElementSibling.querySelectorAll('.tab_panel-box');

    tabItems.forEach((tabItem) => {
      tabItem.classList.remove('is-active');
    })
    tabPanelItems.forEach((tabPanelItem) => {
      tabPanelItem.classList.remove('is-show');
    })
    
    e.currentTarget.classList.add('is-active');

    // クリックしたmenuのデータ属性と等しい値を持つパネルにis-showクラスを付加
    tabPanelItems.forEach((tabPanelItem) => {
      if (tabPanelItem.dataset.panel ===  tabTargetData) {
        tabPanelItem.classList.add('is-show');
      }
    })
  }
}

