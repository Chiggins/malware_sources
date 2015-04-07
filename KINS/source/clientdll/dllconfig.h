/*
  Работа с DllConfig
*/
#pragma once

#include "..\common\binstorage.h"
#include "..\common\crypt.h"

namespace DllConfig
{
  /*
    Инициализация.
  */
  void init(void);
  
  /*
    Деинициализация.
  */
  void uninit(void);
  
  /*
   Init RC4 key from current dll config
   OUT rc4Key - RC4 key
  */
  void getRc4Key(Crypt::RC4KEY *rc4Key);
  /*
    Загрузка текущей конфигурации в память процесса.

    Return - указатель на конфиг(необходимо освободить через Mem), или NULL в случаи ошибки.
  */
  BinStorage::STORAGE *getCurrent(void);

};
