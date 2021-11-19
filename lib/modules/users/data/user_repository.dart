import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:onde_gastei_api/application/database/i_database_connection.dart';
import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_api/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_api/helpers/cripty_helper.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/data/i_user_repository.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_categories_by_percentage_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expense_by_period_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expenses_by_categories_view_model.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  UserRepository({required this.connection, required this.log});

  final IDatabaseConnection connection;
  final ILog log;

  @override
  Future<int> createUser(String name, String email, String password) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
          insert into usuario(nome, email, senha) values (?, ?, ?)
      ''', [name, email, CriptyHelper.generateSha256Hash(password)]);

      return result.insertId ?? 0;
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        log.error('Usuario já cadastrado na base de dados', e, s);
        throw UserExistsException();
      }
      log.error('Erro ao criar usuario', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
         select id_usuario, nome, email from usuario where email = ? and senha = ?
      ''', [email, CriptyHelper.generateSha256Hash(password)]);

      if (result.isEmpty) {
        log.error('usuario ou senha invalidos');
        throw UserNotFoundException();
      } else {
        final userData = result.first;
        return User(
            id: int.parse(userData['id_usuario'].toString()),
            name: userData['nome'].toString(),
            email: userData['email'].toString());
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao fazer login', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> findById(int id) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
      SELECT 
          id_usuario, nome, email
      FROM
          usuario
      WHERE
          id_usuario = ?
      ''', [id]);

      if (result.isEmpty) {
        throw UserNotFoundException(message: 'Usuário não encontrado');
      } else {
        final mysqlData = result.first;

        return User(
          id: int.parse(mysqlData['id_usuario'].toString()),
          name: mysqlData['nome'].toString(),
          email: mysqlData['email'].toString(),
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar usuario por id', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateUserNameById(int userId, String name) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      await conn.query('''
        UPDATE usuario 
        SET 
            nome = ?
        WHERE
            id_usuario = ?     
      ''', [name, userId]);
    } on MySqlException catch (e, s) {
      log.error('Erro ao atualizar nome do usuario $userId', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Category>> findCategoriesByUserId(int userId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
        SELECT 
            id_categoria,
            descricao,
            codigo_icone,
            codigo_cor,
            id_usuario
        FROM
            categoria
        WHERE
            id_usuario = ?      
      ''', [userId]);

      if (result.isNotEmpty) {
        return result
            .map((c) => Category(
                id: int.parse(c['id_categoria'].toString()),
                description: c['descricao'].toString(),
                iconCode: int.parse(c['codigo_icone'].toString()),
                colorCode: int.parse(c['codigo_cor'].toString()),
                userId: userId))
            .toList();
      }

      return <Category>[];
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar categorias do usuario $userId', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<UserExpenseByPeriodViewModel>> findExpenseByPeriod(
      int userId, DateTime initialDate, DateTime finalDate) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
          SELECT 
              d.id_despesa,
              d.descricao,
              d.valor,
              d.data,
              c.id_categoria,
              c.descricao as descricao_categoria,
              c.codigo_icone,
              c.codigo_cor
          FROM
              despesa d
                  INNER JOIN
              categoria c ON (d.id_categoria = c.id_categoria)
          WHERE
              d.id_usuario = ?
                  AND d.data BETWEEN ? AND ?      
      
      ''',
          [userId, initialDate.toIso8601String(), finalDate.toIso8601String()]);

      if (result.isNotEmpty) {
        return result
            .map((d) => UserExpenseByPeriodViewModel(
                expenseId: int.parse(d['id_despesa'].toString()),
                description: d['descricao'].toString(),
                value: double.parse(d['valor'].toString()),
                date: DateTime.parse(d['data'].toString()),
                category: Category(
                  id: int.parse(d['id_categoria'].toString()),
                  description: d['descricao_categoria'].toString(),
                  iconCode: int.parse(d['codigo_icone'].toString()),
                  colorCode: int.parse(d['codigo_cor'].toString()),
                )))
            .toList();
      }

      return <UserExpenseByPeriodViewModel>[];
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar despesas por período', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<UserExpensesByCategoriesViewModel>> findTotalExpensesByCategories(
      int userId, DateTime initialDate, DateTime finalDate) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
          SELECT 
              c.id_categoria, c.descricao, SUM(d.valor) AS valor_total
          FROM
              despesa d
                  INNER JOIN
              categoria c ON (d.id_categoria = c.id_categoria)
          WHERE
              d.id_usuario = ?
                  AND d.data BETWEEN ? AND ?
          GROUP BY c.id_categoria , c.descricao
          ORDER BY valor_total DESC  
      
      ''',
          [userId, initialDate.toIso8601String(), finalDate.toIso8601String()]);

      if (result.isNotEmpty) {
        return result
            .map((d) => UserExpensesByCategoriesViewModel(
                categoryId: int.parse(d['id_categoria'].toString()),
                description: d['descricao'].toString(),
                totalValue: double.parse(d['valor_total'].toString())))
            .toList();
      }

      return <UserExpensesByCategoriesViewModel>[];
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar despesas por categorias', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<UserCategoriesByPercentageViewModel>> findPercentageByCategories(
      int userId, DateTime initialDate, DateTime finalDate) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
              SELECT tab.id_categoria,
                     tab.descricao, 
                     tab.valor_total_categoria,
                     ROUND(((tab.valor_total_categoria / tab.total_geral) * 100), 2) AS percentual_categoria
              FROM
              (SELECT 
                  c.id_categoria,
                  c.descricao,
                  SUM(d.valor) AS valor_total_categoria,
                  SUM(d.valor) over (partition by null) as total_geral
              FROM
                  despesa d
                      INNER JOIN
                  categoria c ON (d.id_categoria = c.id_categoria)
              WHERE
                  d.id_usuario = ?
                      AND d.data BETWEEN ? AND ?
              GROUP BY c.id_categoria , c.descricao , d.valor
              ) tab
              ORDER BY percentual_categoria DESC
      
      ''',
          [userId, initialDate.toIso8601String(), finalDate.toIso8601String()]);

      if (result.isNotEmpty) {
        return result
            .map((c) => UserCategoriesByPercentageViewModel(
                categoryId: int.parse(c['id_categoria'].toString()),
                description: c['descricao'].toString(),
                categoryValue:
                    double.parse(c['valor_total_categoria'].toString()),
                categoryPercentage: double.parse(
                  c['percentual_categoria'].toString(),
                )))
            .toList();
      }

      return <UserCategoriesByPercentageViewModel>[];
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar despesas por categorias', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<UserExpenseByPeriodViewModel>> findExpensesByCategories(
      int userId,
      int categoryId,
      DateTime initialDate,
      DateTime finalDate) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
          SELECT 
              d.id_despesa,
              d.descricao,
              d.valor,
              d.data,
              c.id_categoria,
              c.descricao as descricao_categoria,
              c.codigo_icone,
              c.codigo_cor
          FROM
              despesa d
                  INNER JOIN
              categoria c ON (d.id_categoria = c.id_categoria)
          WHERE
              d.id_usuario = ?
                  AND c.id_categoria = ?
                  AND d.data BETWEEN ? AND ?      
      
      ''', [
        userId,
        categoryId,
        initialDate.toIso8601String(),
        finalDate.toIso8601String()
      ]);

      if (result.isNotEmpty) {
        return result
            .map((d) => UserExpenseByPeriodViewModel(
                expenseId: int.parse(d['id_despesa'].toString()),
                description: d['descricao'].toString(),
                value: double.parse(d['valor'].toString()),
                date: DateTime.parse(d['data'].toString()),
                category: Category(
                  id: int.parse(d['id_categoria'].toString()),
                  description: d['descricao_categoria'].toString(),
                  iconCode: int.parse(d['codigo_icone'].toString()),
                  colorCode: int.parse(d['codigo_cor'].toString()),
                )))
            .toList();
      }

      return <UserExpenseByPeriodViewModel>[];
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar despesas por período', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> confirmLogin(int userId, String refreshToken) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      await conn.query('''
        UPDATE usuario
        SET
          refresh_token = ?
        WHERE id_usuario = ?            
      
      ''', [refreshToken, userId]);
    } on MySqlException catch (e, s) {
      log.error('Erro ao confirmar login', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateRefreshToken(int userId, String refreshToken) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      await conn.query(
          'update usuario set refresh_token = ? where id_usuario = ?',
          [refreshToken, userId]);
    } on MySqlException catch (e, s) {
      log.error('Erro ao atualizar refresh token', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
