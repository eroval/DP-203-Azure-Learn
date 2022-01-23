﻿using Azure.Messaging.EventHubs.Consumer;
using System;
using System.Text;
using System.Threading.Tasks;

namespace AzureEventHub_Receive
{
    class Program
    {
        private static string connection_string = "Endpoint=sb://myeventhubbro.servicebus.windows.net/;SharedAccessKeyName=mynewpolicy;SharedAccessKey=yX+DR0VFiJovfj3hIE0a8N5SoAFQmQeYX7ADecZjZ1s=;EntityPath=myeventhub";
        private static string consumer_group="$Default";
        static async Task Main(string[] args)
        {
            EventHubConsumerClient _client = new EventHubConsumerClient(consumer_group, connection_string);

            await foreach(PartitionEvent _event in _client.ReadEventsAsync())
            {
                Console.WriteLine($"Partition ID {_event.Partition.PartitionId}");
                Console.WriteLine($"Data Offset {_event.Data.Offset}");
                Console.WriteLine($"Sequence Number {_event.Data.SequenceNumber}");
                Console.WriteLine($"Partition Key {_event.Data.PartitionKey}");
                Console.WriteLine(Encoding.UTF8.GetString(_event.Data.EventBody));
            }
            Console.ReadKey();
        }
    }
}
