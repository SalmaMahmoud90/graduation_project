import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../exceptions/app_exception.dart';
import '../exceptions/local_exception.dart';


@lazySingleton
class LocalStorageHelper {


  Future<Either<AppException, Box>> _getBox(
      String boxName,
      ) async {

    try {

      if (Hive.isBoxOpen(boxName)) {
        return Right(Hive.box(boxName));
      }


      final box = await Hive.openBox(boxName);

      return Right(box);


    } catch (e) {

      return Left(
        BoxOpenException(
          'Failed to open box: $boxName',
        ),
      );
    }
  }



  Future<Either<AppException, dynamic>> saveValue(
      String boxName,
      String key,
      dynamic value,
      ) async {


    final boxResult = await _getBox(boxName);


    return boxResult.fold(
          (error) => Left(error),

          (box) async {

        try {

          await box.put(key, value);

          return Right(
              box.get(key)
          );


        } catch(e){

          return Left(
            StoreValueException(
              'Failed to save value to box: $boxName',
            ),
          );
        }
      },
    );
  }




  Future<Either<AppException, dynamic>> getValue(
      String boxName,
      String key,
      ) async {


    final boxResult = await _getBox(boxName);


    return boxResult.fold(
          (error)=>Left(error),

          (box){

        try {

          return Right(
              box.get(key)
          );


        }catch(e){

          return Left(
            GetValueException(
              'Failed to retrieve value from box: $boxName',
            ),
          );

        }

      },
    );
  }





  Future<Either<AppException,List<dynamic>>> getAll(
      String boxName,
      ) async {


    final boxResult = await _getBox(boxName);


    return boxResult.fold(
          (error)=>Left(error),

          (box){

        try {

          return Right(
              box.values.toList()
          );


        }catch(e){

          return Left(
            GetValueException(
              'Failed to retrieve values from box: $boxName',
            ),
          );

        }
      },
    );
  }





  Future<Either<AppException,bool>> deleteValue(
      String boxName,
      String key,
      ) async {


    final boxResult = await _getBox(boxName);


    return boxResult.fold(
          (error)=>Left(error),

          (box) async {


        try {

          await box.delete(key);

          return const Right(true);


        }catch(e){

          return Left(
            DeleteValueException(
              'Failed deleting value from box: $boxName',
            ),
          );

        }

      },
    );
  }





  Future<Either<AppException,bool>> containsKey(
      String boxName,
      String key,
      ) async {


    final boxResult = await _getBox(boxName);


    return boxResult.fold(
          (error)=>Left(error),

          (box){

        try {

          return Right(
              box.containsKey(key)
          );


        }catch(e){

          return Left(
            NotFoundValueException(
              'Failed checking key in box: $boxName',
            ),
          );
        }

      },
    );
  }






  Future<Either<AppException,Unit>> clearBox(
      String boxName,
      ) async {


    final boxResult = await _getBox(boxName);


    return boxResult.fold(
          (error)=>Left(error),

          (box) async {

        try {

          await box.clear();

          return const Right(unit);


        }catch(e){

          return Left(
            ClearBoxException(
              'Failed clearing box: $boxName',
            ),
          );

        }
      },
    );
  }





  Stream<BoxEvent>? listenToBox(
      String boxName,
      String key,
      ) {


    if(!Hive.isBoxOpen(boxName)){
      return null;
    }


    return Hive.box(boxName)
        .watch(key:key);
  }


Future<Either<AppException, Box>> openBox(
  String boxName,
) async {
  return _getBox(boxName);
}

}