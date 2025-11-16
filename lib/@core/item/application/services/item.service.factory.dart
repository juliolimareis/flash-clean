import 'package:flash_clean/@core/item/infra/item.repository.dart';
import 'package:flash_clean/@core/item/infra/userItem.repository.dart';
import 'package:flash_clean/@core/item/application/services/item.service.dart';
import 'package:flash_clean/@core/common/infra/drvers/supabase.database.driver.dart';

class ItemServiceFactory {
  static buildSupabase() {
    final supabaseDatabaseDriverItem = SupabaseDatabaseDriver(
      tableName: 'item',
    );
    final supabaseDatabaseDriverUserItem = SupabaseDatabaseDriver(
      tableName: 'userItem',
    );

    final itemRepository = ItemRepository(adapter: supabaseDatabaseDriverItem);
    final userItemRepository = UserItemRepository(
      adapter: supabaseDatabaseDriverUserItem,
    );

    return ItemService(
      itemRepository: itemRepository,
      userItemRepository: userItemRepository,
    );
  }
}
