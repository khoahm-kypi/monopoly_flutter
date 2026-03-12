import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Language { en, vi }

class LanguageNotifier extends Notifier<Language> {
  @override
  Language build() => Language.en;

  void setLanguage(Language lang) => state = lang;
}

final languageProvider = NotifierProvider<LanguageNotifier, Language>(() {
  return LanguageNotifier();
});

class AppStrings {
  static String get(Language lang, String key, {Map<String, String>? params}) {
    String text;
    if (lang == Language.vi) {
      text = _vi[key] ?? _en[key] ?? key;
    } else {
      text = _en[key] ?? key;
    }

    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }
    return text;
  }

  static const Map<String, String> _en = {
    'setup_title': 'MonoTravel Setup',
    'num_players': 'Number of Players:',
    'players_count': '{count} Players',
    'initial_money': 'Initial Money:',
    'go_salary': 'GO Salary:',
    'player_name_label': 'Player Name',
    'bot_toggle': 'Bot?',
    'start_game': 'START GAME',
    'exit_game': 'Exit Game',
    'game_log': 'GAME LOG',
    'turn_of': 'Turn of: {name}',
    'assets_of': 'Assets: {name}',
    'game_history': 'Game History',
    'no_actions': 'No actions',
    'close': 'Close',
    'roll_dice': 'ROLL DICE',
    'turn_suffix': "'s Turn",
    'buy_property_title': 'Property: {name}',
    'buy_price': 'Purchase Price: {price}',
    'rent_price': 'Rent: {price}',
    'buy_confirm': 'Do you want to buy this property?',
    'skip': 'Skip',
    'buy_now': 'Buy Now',
    'upgrade_title': 'Upgrade: {name}',
    'current_houses': 'Current houses: {count}',
    'current_rent': 'Current rent: {price}',
    'upgrade_cost': 'Upgrade price: {price}',
    'next_rent': 'Next rent: {price}',
    'upgrade_confirm': 'Do you want to build another house?',
    'build': 'Build',
    'chance': 'CHANCE',
    'confirm': 'Confirm',
    'go': 'GO',
    'jail': 'JAIL',
    'parking': 'FREE PARKING',
    'go_to_jail': 'GO TO JAIL',
    'tax': 'TAX',
    'tax_amount': 'TAX\n({amount})',
    'log_start': 'New game started!',
    'log_pass_go': '{name} passed GO, received {amount}',
    'log_pay_rent': '{name} paid {amount} rent to {owner}',
    'log_bankrupt': '{name} is bankrupt!',
    'log_buy': '{name} bought {property} for {price}',
    'log_upgrade': '{name} upgraded {property} (Level {level})',
    'log_tax': '{name} paid {amount} tax',
    'log_bankrupt_tax': '{name} is bankrupt due to unpaid taxes!',
    'log_chance_move': '{name} moves by Chance card',
    'log_chance_result': 'Card result: {desc}',
    'log_turn': "[TURN] {name}'s turn",
    'log_release_jail': '{name} released from jail',
    'log_bot_buy': '{name} (Bot) automatically bought {property}',
    'log_bot_upgrade': '{name} (Bot) upgraded {property}',
    'log_insufficient_funds': '{name} does not have enough money to buy {property}',
    'system': 'System',
    'resume_game': 'RESUME GAME',
    'language_label': 'Language:',
    'chance_c1': 'Bank error in your favor! Collect \$50.',
    'chance_c2': 'Traffic violation. Pay fine \$20.',
    'chance_c3': 'Lottery win! Receive \$100.',
    'chance_c4': 'Advance to GO (Collect \$200).',
    'chance_c5': 'Lost wallet. Lose \$30.',
    'chance_c6': 'Medical fees. Spend \$50.',
  };

  static const Map<String, String> _vi = {
    'setup_title': 'Cấu hình MonoTravel',
    'num_players': 'Số lượng người chơi:',
    'players_count': '{count} Người chơi',
    'initial_money': 'Tiền khởi đầu:',
    'go_salary': 'Tiền qua trạm:',
    'player_name_label': 'Tên người chơi',
    'bot_toggle': 'Máy?',
    'start_game': 'BẮT ĐẦU',
    'exit_game': 'Thoát game',
    'game_log': 'NHẬT KÝ',
    'turn_of': 'Lượt của: {name}',
    'assets_of': 'Tài sản: {name}',
    'game_history': 'Lịch sử trận đấu',
    'no_actions': 'Không có hành động',
    'close': 'Đóng',
    'roll_dice': 'TUNG XÚC XẮC',
    'turn_suffix': ' đến lượt',
    'buy_property_title': 'Lô đất: {name}',
    'buy_price': 'Giá mua: {price}',
    'rent_price': 'Tiền thuê: {price}',
    'buy_confirm': 'Bạn có muốn mua lô đất này không?',
    'skip': 'Bỏ qua',
    'buy_now': 'Mua ngay',
    'upgrade_title': 'Nâng cấp: {name}',
    'current_houses': 'Số nhà hiện tại: {count}',
    'current_rent': 'Tiền thuê hiện tại: {price}',
    'upgrade_cost': 'Giá nâng cấp: {price}',
    'next_rent': 'Tiền thuê cấp tới: {price}',
    'upgrade_confirm': 'Bạn có muốn xây thêm nhà không?',
    'build': 'Xây dựng',
    'chance': 'CƠ HỘI',
    'confirm': 'Xác nhận',
    'go': 'XUẤT PHÁT',
    'jail': 'NHÀ TÙ',
    'parking': 'BÃI ĐỖ XE',
    'go_to_jail': 'VÀO TÙ',
    'tax': 'THUẾ',
    'tax_amount': 'THUẾ\n({amount})',
    'log_start': 'Trận đấu mới bắt đầu!',
    'log_pass_go': '{name} đi qua vạch Xuất Phát, nhận {amount}',
    'log_pay_rent': '{name} đã trả {amount} tiền thuê cho {owner}',
    'log_bankrupt': '{name} đã phá sản!',
    'log_buy': '{name} đã mua {property} với giá {price}',
    'log_upgrade': '{name} đã nâng cấp {property} (Cấp {level})',
    'log_tax': '{name} đã nộp {amount} tiền thuế',
    'log_bankrupt_tax': '{name} đã phá sản do không đủ tiền nộp thuế!',
    'log_chance_move': '{name} di chuyển theo thẻ Cơ Hội',
    'log_chance_result': 'Kết quả thẻ: {desc}',
    'log_turn': '[TURN] Lượt của {name}',
    'log_release_jail': '{name} đã ra tù',
    'log_bot_buy': '{name} (Bot) đã tự động mua {property}',
    'log_bot_upgrade': '{name} (Bot) đã nâng cấp {property}',
    'log_insufficient_funds': '{name} không đủ tiền để mua {property}',
    'system': 'Hệ thống',
    'resume_game': 'TIẾP TỤC',
    'language_label': 'Ngôn ngữ:',
    'chance_c1': 'Lỗi nạp thẻ! Ngân hàng hoàn lại cho bạn \$50.',
    'chance_c2': 'Vi phạm luật giao thông. Nộp phạt \$20.',
    'chance_c3': 'Trúng thưởng xổ số! Nhận \$100.',
    'chance_c4': 'Tiến về vạch Xuất Phát (Nhận \$200).',
    'chance_c5': 'Rơi ví tiền. Mất \$30.',
    'chance_c6': 'Chi phí y tế. Nộp \$50.',
  };
}
